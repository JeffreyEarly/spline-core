classdef BSpline < handle
    % create and evaluate b-splines
    %
    % The BSpline 
    %
    % - Topic: Initialization
    % - Topic: Primary attributes
    %
    % - Declaration: classdef BSpline < handle
    properties (SetObservable, AbortSet, Access = public)
        % order of polynomial 
        % - Topic: Primary attributes
        K

        % coefficients (Mx1) 
        % - Topic: Primary attributes
        xi

        % knot points
        % - Topic: Primary attributes
        tKnot
    end

    properties (GetAccess=public, SetAccess=protected)
        % splines at the points tpp
        % - Topic: Spline evalutation
        Xtpp = [];

        % piece-wise polynomial break points
        % - Topic: Spline evalutation
        % size(t_pp) = length(tKnot) - 2*K + 1
        t_pp

        % piecewise polynomial coefficients
        % - Topic: Spline evalutation
        % size(C) = [length(t_pp)-1, K]
        C       
    end
    
    properties (Access=public)
        x_mean = 0 % if set, these will be used to scale the output
        x_std = 1 % x_out = x_std*(X*m)+x_mean;
    end

    properties (Dependent)
        % degree of the polynomial (S=K-1)
        % - Topic: Primary attributes
        % A cubic spline is K=4, S=3
        S

        % min and max value of the independent variable
        % - Topic: Primary attributes
        domain
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
        function self = BSpline(K,tKnot,m,options)
            % create a new BSpline instance
            %
            % Creates a new instance of BSpline
            %
            % - Topic: Initialization
            % - Declaration: spline = BSpline(K,tKnot,m)
            % - Parameter K: spline order (degree S=K-1)
            % - Parameter tKnot: knot points
            % - Parameter m: (optional) spline coefficients
            arguments
                K (1,1) double {mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
                tKnot (:,1) double {mustBeNumeric,mustBeReal}
                m (:,1) double = zeros(length(tKnot)-K,1)
                options.Xtpp (:,:,:) double
                options.x_mean = 0
                options.x_std = 1
            end
            self.K = K;   
            self.tKnot = tKnot;
            self.xi = m;
            self.x_mean = options.x_mean;
            self.x_std = options.x_std;
            if isfield(options,'Xtpp')
                self.Xtpp = options.Xtpp;
            end
            self.splineCoefficientsDidChange([],[]);

            addlistener(self,'xi','PostSet',@self.splineCoefficientsDidChange);
            addlistener(self,'tKnot','PostSet',@self.tKnotDidChange);            
        end
        
        function S = get.S(self)
            S = self.K-1;
        end
        
        function domain = get.domain(self)
            domain = [self.tKnot(1) self.tKnot(end)];
        end
        
        function x_out = valueAtPoints( self, t, NumDerivatives)
            % evaluate the spline (and its derivatives) at arbitrary points t
            %
            % - Topic: Operations
            if ~exist('NumDerivatives','var')
                NumDerivatives = 0;
            end
            x_out = BSpline.evaluateFromPPCoefficients(t,self.C,self.t_pp,NumDerivatives);
            if ~isempty(self.x_std)
                x_out = self.x_std*x_out;
            end
            if ~isempty(self.x_mean) && NumDerivatives == 0
                x_out = x_out + self.x_mean;
            end
        end
        
        function tKnotDidChange(self,~,~)
            self.Xtpp = [];
            self.C = [];
            self.t_pp = [];
            self.xi = [];
        end
        
        function splineCoefficientsDidChange(self,~,~)
            if isempty(self.xi)
                self.C = [];
                self.t_pp = [];
                self.Xtpp = [];
                return;
            end
            [self.C,self.t_pp,self.Xtpp] = BSpline.ppCoefficientsFromSplineCoefficients( self.xi, self.tKnot, self.K, Xtpp=self.Xtpp );
        end
    end
    
    methods (Static)
        t_knot = knotPointsForDataPoints( t, options)
        t = pointsOfSupport(tKnot,K,D)
        [C,tpp,Xtpp] = ppCoefficientsFromSplineCoefficients( m, tKnot, K, options )
        f = evaluateFromPPCoefficients(t,C,tpp, D)
        B = matrix( t, tKnot, K, options )
    end
end

