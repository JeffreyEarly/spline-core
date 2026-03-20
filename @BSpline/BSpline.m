classdef BSpline < handle
    % Create, evaluate, and manipulate terminated B-spline representations.
    %
    % BSpline stores a spline basis order, knot sequence, and spline
    % coefficients together with cached piecewise-polynomial coefficients for
    % efficient evaluation, differentiation, and algebraic transforms.
    %
    % - Topic: Initialization
    % - Topic: Primary attributes
    % - Topic: Spline evaluation
    % - Topic: Operations
    % - Topic: Utility
    % - Topic: Methodology (Static methods)
    %
    % - Declaration: classdef BSpline < handle
    properties (Access = public)
        % Spline order K, where polynomial degree is S = K - 1.
        %
        % - Topic: Primary attributes
        K
    end

    properties (Access = private)
        % Internal spline coefficients, stored as an Mx1 vector.
        %
        % - Topic: Primary attributes
        xi_

        % Internal knot sequence for the spline basis.
        %
        % - Topic: Primary attributes
        tKnot_
    end

    properties (GetAccess=public, SetAccess=protected)
        % Basis values and derivatives sampled at piecewise breakpoints.
        %
        % - Topic: Spline evaluation
        Xtpp = [];

        % Piecewise-polynomial breakpoint locations.
        %
        % - Topic: Spline evaluation
        % size(t_pp) = length(tKnot) - 2*K + 1
        t_pp

        % Piecewise-polynomial coefficients for interval evaluation.
        %
        % - Topic: Spline evaluation
        % size(C) = [length(t_pp)-1, K]
        C       
    end
    
    properties (Access=public)
        % Mean added back to zero-order spline evaluations.
        %
        % - Topic: Primary attributes
        x_mean = 0 % if set, these will be used to scale the output
        % Multiplicative scale applied to spline evaluations.
        %
        % - Topic: Primary attributes
        x_std = 1 % x_out = x_std*(X*xi)+x_mean;
    end

    properties (Dependent)
        % Polynomial degree S = K - 1.
        %
        % - Topic: Primary attributes
        % A cubic spline is K=4, S=3
        S

        % Minimum and maximum values of the spline domain.
        %
        % - Topic: Primary attributes
        domain

        % Spline coefficients as an Mx1 vector.
        %
        % - Topic: Primary attributes
        xi

        % Knot sequence used to define the spline basis.
        %
        % - Topic: Primary attributes
        tKnot
    end
    
    methods
        function varargout = subsref(self, index)
            % Evaluate the spline with function-call syntax or defer to built-in indexing.
            %
            % Parentheses indexing `spline(t)` is redirected to
            % `valueAtPoints`, while dot indexing behaves like the default
            % MATLAB handle-class implementation.
            %
            % - Topic: Operations
            % - Declaration: varargout = subsref(self,index)
            % - Parameter self: BSpline instance
            % - Parameter index: MATLAB subscript structure
            % - Returns varargout: indexed property access or spline values
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
            % Create a new B-spline representation from order, knots, and coefficients.
            %
            % Optionally accepts cached breakpoint evaluations and affine
            % output normalization parameters used by derived spline classes.
            %
            % - Topic: Initialization
            % - Declaration: spline = BSpline(K,tKnot,xi)
            % - Parameter K: spline order (degree S=K-1)
            % - Parameter tKnot: knot points
            % - Parameter xi: (optional) spline coefficients
            % - Parameter options.Xtpp: optional cached basis values at piecewise breakpoints
            % - Parameter options.x_mean: optional additive output offset
            % - Parameter options.x_std: optional multiplicative output scale
            % - Returns spline: BSpline instance
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
            % Return the spline polynomial degree.
            %
            % - Topic: Primary attributes
            % - Declaration: S = get.S(self)
            % - Parameter self: BSpline instance
            % - Returns S: double scalar equal to K - 1
            S = self.K-1;
        end
        
        function domain = get.domain(self)
            % Return the spline domain endpoints.
            %
            % - Topic: Primary attributes
            % - Declaration: domain = get.domain(self)
            % - Parameter self: BSpline instance
            % - Returns domain: 1x2 vector [tMin tMax]
            domain = [self.tKnot(1) self.tKnot(end)];
        end

        function xi = get.xi(self)
            % Return the current spline coefficients.
            %
            % - Topic: Primary attributes
            % - Declaration: xi = get.xi(self)
            % - Parameter self: BSpline instance
            % - Returns xi: spline coefficient column vector
            xi = self.xi_;
        end

        function set.xi(self, xi)
            % Update spline coefficients and refresh cached polynomial forms.
            %
            % - Topic: Primary attributes
            % - Declaration: set.xi(self,xi)
            % - Parameter self: BSpline instance
            % - Parameter xi: spline coefficient column vector
            arguments
                self (1,1) BSpline
                xi (:,1) double
            end
            self.xi_ = xi;
            self.splineCoefficientsDidChange();
        end

        function tKnot = get.tKnot(self)
            % Return the current knot sequence.
            %
            % - Topic: Primary attributes
            % - Declaration: tKnot = get.tKnot(self)
            % - Parameter self: BSpline instance
            % - Returns tKnot: knot vector
            tKnot = self.tKnot_;
        end

        function set.tKnot(self, tKnot)
            % Update the knot sequence and clear cached spline state.
            %
            % - Topic: Primary attributes
            % - Declaration: set.tKnot(self,tKnot)
            % - Parameter self: BSpline instance
            % - Parameter tKnot: knot vector
            arguments
                self (1,1) BSpline
                tKnot (:,1) double {mustBeNumeric,mustBeReal}
            end
            self.tKnot_ = tKnot;
            self.tKnotDidChange();
        end
        
        function x_out = valueAtPoints( self, t, NumDerivatives)
            % Evaluate the spline or one of its derivatives at arbitrary points.
            %
            % - Topic: Operations
            % - Declaration: x_out = valueAtPoints(self,t,NumDerivatives)
            % - Parameter self: BSpline instance
            % - Parameter t: evaluation points
            % - Parameter NumDerivatives: derivative order to evaluate
            % - Note: derivative orders above K-1 evaluate to zero.
            % - Returns x_out: array matching the shape of t
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
            % Clear cached piecewise-polynomial data after knot updates.
            %
            % - Topic: Utility
            % - Declaration: tKnotDidChange(self)
            % - Parameter self: BSpline instance
            self.Xtpp = [];
            self.C = [];
            self.t_pp = [];
            self.xi_ = [];
        end
        
        function splineCoefficientsDidChange(self)
            % Refresh cached polynomial coefficients after coefficient updates.
            %
            % - Topic: Utility
            % - Declaration: splineCoefficientsDidChange(self)
            % - Parameter self: BSpline instance
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
            % Apply an affine transform to spline outputs without refitting.
            %
            % - Topic: Utility
            % - Declaration: transformedSpline = affineOutputTransform(self,scale,offset)
            % - Parameter self: BSpline instance
            % - Parameter scale: output scale factor
            % - Parameter offset: output offset
            % - Returns transformedSpline: BSpline with adjusted output normalization
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
