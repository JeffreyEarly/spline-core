classdef BSpline < handle
    % Create, evaluate, and manipulate terminated B-spline representations.
    %
    % BSpline stores a spline basis order, knot sequence, and spline
    % coefficients together with cached piecewise-polynomial coefficients for
    % efficient evaluation, differentiation, and algebraic transforms.
    %
    % ## Basic usage
    %
    % In most workflows you first build a knot sequence from sample
    % locations, assemble the spline basis matrix, solve for coefficients,
    % and then evaluate the resulting spline object.
    %
    % ```matlab
    % t = linspace(0,1,20)';
    % x = sin(2*pi*t);
    % tKnot = BSpline.knotPointsForDataPoints(t, K=4);
    % X = BSpline.matrix(t, tKnot, 4);
    % spline = BSpline(4, tKnot, X\x);
    %
    % xq = spline(linspace(0,1,100)');
    % ```
    %
    % - Topic: Create a spline
    % - Topic: Inspect spline properties
    % - Topic: Evaluate the spline
    % - Topic: Transform the spline
    % - Topic: Build spline bases
    % - Topic: Represent piecewise polynomials
    % - Topic: Maintain cached state
    %
    % - Declaration: classdef BSpline < handle
    properties (Access = public)
        % Spline order K, where polynomial degree is S = K - 1.
        %
        % - Topic: Inspect spline properties
        K
    end

    properties (Access = private)
        % Internal spline coefficients, stored as an Mx1 vector.
        %
        % - Topic: Inspect spline properties
        xi_

        % Internal knot sequence for the spline basis.
        %
        % - Topic: Inspect spline properties
        tKnot_
    end

    properties (GetAccess=public, SetAccess=protected)
        % Basis values and derivatives sampled at piecewise breakpoints.
        %
        % - Topic: Represent piecewise polynomials
        % - Developer: true
        Xtpp = [];

        % Piecewise-polynomial breakpoint locations.
        %
        % - Topic: Represent piecewise polynomials
        % - Developer: true
        % size(t_pp) = length(tKnot) - 2*K + 1
        t_pp

        % Piecewise-polynomial coefficients for interval evaluation.
        %
        % - Topic: Represent piecewise polynomials
        % - Developer: true
        % size(C) = [length(t_pp)-1, K]
        C       
    end
    
    properties (SetAccess = private)
        % Mean added back to zero-order spline evaluations.
        %
        % - Topic: Inspect spline properties
        xMean (1,1) double {mustBeReal,mustBeFinite} = 0
        % Multiplicative scale applied to spline evaluations.
        %
        % - Topic: Inspect spline properties
        xStd (1,1) double {mustBeReal,mustBeFinite} = 1
    end

    properties (Dependent)
        % Polynomial degree S = K - 1.
        %
        % - Topic: Inspect spline properties
        % A cubic spline is K=4, S=3
        S

        % Minimum and maximum values of the spline domain.
        %
        % - Topic: Inspect spline properties
        domain

        % Spline coefficients as an Mx1 vector.
        %
        % - Topic: Inspect spline properties
        xi
    end

    properties (Dependent, SetAccess = private)

        % Knot sequence used to define the spline basis.
        %
        % - Topic: Inspect spline properties
        tKnot
    end
    
    methods
        varargout = subsref(self, index)
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
            % Use this constructor when you already have a knot sequence and
            % coefficient vector and want a spline object for evaluation or
            % algebraic manipulation.
            %
            % ```matlab
            % tKnot = [0; 0; 0; 0; 1; 1; 1; 1];
            % xi = [1; -0.5; 0.25; 0];
            % spline = BSpline(4, tKnot, xi);
            % x = spline(linspace(0,1,50)');
            % ```
            %
            % - Topic: Create a spline
            % - Declaration: spline = BSpline(K,tKnot,xi)
            % - Parameter K: spline order (degree S=K-1)
            % - Parameter tKnot: knot points
            % - Parameter xi: (optional) spline coefficients
            % - Parameter options.Xtpp: optional cached basis values at piecewise breakpoints
            % - Parameter options.xMean: optional additive output offset
            % - Parameter options.xStd: optional multiplicative output scale
            % - Returns spline: BSpline instance
            arguments
                K (1,1) double {mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
                tKnot (:,1) double {mustBeNumeric,mustBeReal}
                xi (:,1) double = zeros(length(tKnot)-K,1)
                options.Xtpp (:,:,:) double
                options.xMean (1,1) double {mustBeReal,mustBeFinite} = 0
                options.xStd (1,1) double {mustBeReal,mustBeFinite} = 1
            end
            self.K = K;   
            self.tKnot_ = tKnot;
            self.xi_ = xi;
            self.xMean = options.xMean;
            self.xStd = options.xStd;
            if isfield(options,'Xtpp')
                self.Xtpp = options.Xtpp;
            end
            self.splineCoefficientsDidChange();
        end
        
        function S = get.S(self)
            % Return the spline polynomial degree.
            %
            % - Topic: Inspect spline properties
            % - Declaration: S = get.S(self)
            % - Parameter self: BSpline instance
            % - Returns S: double scalar equal to K - 1
            S = self.K-1;
        end
        
        function domain = get.domain(self)
            % Return the spline domain endpoints.
            %
            % - Topic: Inspect spline properties
            % - Declaration: domain = get.domain(self)
            % - Parameter self: BSpline instance
            % - Returns domain: 1x2 vector [tMin tMax]
            domain = [self.tKnot(1) self.tKnot(end)];
        end

        function xi = get.xi(self)
            % Return the current spline coefficients.
            %
            % - Topic: Inspect spline properties
            % - Declaration: xi = get.xi(self)
            % - Parameter self: BSpline instance
            % - Returns xi: spline coefficient column vector
            xi = self.xi_;
        end

        function set.xi(self, xi)
            % Update spline coefficients and refresh cached polynomial forms.
            %
            % - Topic: Inspect spline properties
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
            % - Topic: Inspect spline properties
            % - Declaration: tKnot = get.tKnot(self)
            % - Parameter self: BSpline instance
            % - Returns tKnot: knot vector
            tKnot = self.tKnot_;
        end
        
        x_out = valueAtPoints(self, t, NumDerivatives)
        tKnotDidChange(self)
        splineCoefficientsDidChange(self)
    end

    methods (Access = private)
        transformedSpline = affineOutputTransform(self, scale, offset)
    end
    
    methods (Static)
        tKnot = knotPointsForDataPoints( t, options)
        t = pointsOfSupport(tKnot,K,D)
        [C,tpp,Xtpp] = ppCoefficientsFromSplineCoefficients( xi, tKnot, K, options )
        f = evaluateFromPPCoefficients(t,C,tpp, D)
        B = matrix( t, tKnot, K, options )
    end
end
