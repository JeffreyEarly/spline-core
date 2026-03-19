classdef BSpline < handle
    % create and evaluate b-splines
    %
    % The BSpline 
    %
    % - Topic: Initialization
    % - Topic: Primary attributes
    %
    % - Declaration: classdef BSpline < handle
    properties (Access = public)
        % order of polynomial 
        % - Topic: Primary attributes
        K
    end

    properties (Access = private)
        % coefficients (Mx1) 
        % - Topic: Primary attributes
        xi_

        % knot points
        % - Topic: Primary attributes
        tKnot_
    end

    properties (GetAccess=public, SetAccess=protected)
        % splines at the points tpp
        % - Topic: Spline evaluation
        Xtpp = [];

        % piece-wise polynomial break points
        % - Topic: Spline evaluation
        % size(t_pp) = length(tKnot) - 2*K + 1
        t_pp

        % piecewise polynomial coefficients
        % - Topic: Spline evaluation
        % size(C) = [length(t_pp)-1, K]
        C       
    end
    
    properties (Access=public)
        x_mean = 0 % if set, these will be used to scale the output
        x_std = 1 % x_out = x_std*(X*xi)+x_mean;
    end

    properties (Dependent)
        % degree of the polynomial (S=K-1)
        % - Topic: Primary attributes
        % A cubic spline is K=4, S=3
        S

        % min and max value of the independent variable
        % - Topic: Primary attributes
        domain

        % coefficients (Mx1)
        % - Topic: Primary attributes
        xi

        % knot points
        % - Topic: Primary attributes
        tKnot
    end
    
    methods
        function varargout = subsref(self, index)
            %% Subscript overload
            %
            % The forces subscript notation to behave as if it is
            % evaluating a function.
            idx = index(1).subs;
            switch index(1).type
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FEVAL / COMPOSE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case '()'
                    if length(idx) >= 1
                        t = idx{1};
                    end

                    if length(idx) >= 2
                        NumDerivatives = idx{2};
                    else
                        NumDerivatives = 0;
                    end

                    varargout{1} = self.valueAtPoints(t, NumDerivatives);

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case '.'
                    [varargout{1:nargout}] = builtin('subsref',self,index);

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RESTRICT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case '{}'
                    error('The BSpline class does not know what to do with {}.');
                otherwise
                    error('Unexpected syntax');
            end

        end
    end

    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Initialization
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function self = BSpline(K,tKnot,xi,options)
            % create a new BSpline instance
            %
            % Creates a new instance of BSpline
            %
            % - Topic: Initialization
            % - Declaration: spline = BSpline(K,tKnot,xi)
            % - Parameter K: spline order (degree S=K-1)
            % - Parameter tKnot: knot points
            % - Parameter xi: (optional) spline coefficients
            arguments
                K (1,1) double {mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
                tKnot (:,1) double {mustBeNumeric,mustBeReal}
                xi (:,1) double = zeros(length(tKnot)-K,1)
                options.Xtpp (:,:,:) double
                options.x_mean = 0
                options.x_std = 1
            end
            self.K = K;   
            self.tKnot_ = tKnot;
            self.xi_ = xi;
            self.x_mean = options.x_mean;
            self.x_std = options.x_std;
            if isfield(options,'Xtpp')
                self.Xtpp = options.Xtpp;
            end
            self.splineCoefficientsDidChange();
        end
        
        function S = get.S(self)
            S = self.K-1;
        end
        
        function domain = get.domain(self)
            domain = [self.tKnot(1) self.tKnot(end)];
        end

        function xi = get.xi(self)
            xi = self.xi_;
        end

        function set.xi(self, xi)
            arguments
                self (1,1) BSpline
                xi (:,1) double
            end
            self.xi_ = xi;
            self.splineCoefficientsDidChange();
        end

        function tKnot = get.tKnot(self)
            tKnot = self.tKnot_;
        end

        function set.tKnot(self, tKnot)
            arguments
                self (1,1) BSpline
                tKnot (:,1) double {mustBeNumeric,mustBeReal}
            end
            self.tKnot_ = tKnot;
            self.tKnotDidChange();
        end
        
        function x_out = valueAtPoints( self, t, NumDerivatives)
            % evaluate the spline (and its derivatives) at arbitrary points t
            %
            % - Topic: Operations
            % - Note: derivative orders above K-1 evaluate to zero.
            arguments
                self (1,1) BSpline
                t {mustBeNumeric,mustBeReal}
                NumDerivatives (1,1) double {mustBeInteger,mustBeNonnegative} = 0
            end
            if NumDerivatives > self.K-1
                x_out = zeros(size(t), 'like', t);
                return;
            end
            x_out = BSpline.evaluateFromPPCoefficients(t,self.C,self.t_pp,NumDerivatives);
            if ~isempty(self.x_std)
                x_out = self.x_std*x_out;
            end
            if ~isempty(self.x_mean) && NumDerivatives == 0
                x_out = x_out + self.x_mean;
            end
        end
        
        function tKnotDidChange(self)
            self.Xtpp = [];
            self.C = [];
            self.t_pp = [];
            self.xi_ = [];
        end
        
        function splineCoefficientsDidChange(self)
            if isempty(self.xi_)
                self.C = [];
                self.t_pp = [];
                self.Xtpp = [];
                return;
            end
            [self.C,self.t_pp,self.Xtpp] = BSpline.ppCoefficientsFromSplineCoefficients( self.xi_, self.tKnot_, self.K, Xtpp=self.Xtpp );
        end
    end

    methods (Access = private)
        function transformedSpline = affineOutputTransform(self, scale, offset)
            arguments
                self (1,1) BSpline
                scale (1,1) double
                offset (1,1) double
            end

            transformedSpline = BSpline(self.K,self.tKnot,self.xi);
            transformedSpline.x_std = scale*self.x_std;
            transformedSpline.x_mean = scale*self.x_mean + offset;
        end
    end
    
    methods (Static)
        tKnot = knotPointsForDataPoints( t, options)
        t = pointsOfSupport(tKnot,K,D)
        [C,tpp,Xtpp] = ppCoefficientsFromSplineCoefficients( xi, tKnot, K, options )
        f = evaluateFromPPCoefficients(t,C,tpp, D)
        B = matrix( t, tKnot, K, options )
    end
end
