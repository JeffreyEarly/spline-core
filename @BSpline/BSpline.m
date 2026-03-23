classdef BSpline < handle
    % Create, evaluate, and manipulate one-dimensional terminated B-splines.
    %
    % `BSpline` is the low-level one-dimensional spline object used by the
    % higher-level interpolation and fitting classes. It stores a spline
    % degree `S`, a terminated knot sequence `knotPoints`, and a coefficient
    % vector `xi`, then caches an equivalent piecewise-polynomial
    % representation for fast evaluation.
    %
    % Mathematically, the stored spline is
    %
    % $$
    % f(t) = x_{\mathrm{Mean}} + x_{\mathrm{Std}} \sum_{j=1}^{M} \xi_j B_{j,S}(t;\tau),
    % $$
    %
    % where $$\tau$$ is the terminated knot sequence, $$B_{j,S}$$ are the
    % one-dimensional B-spline basis functions of degree $$S$$, and
    % `xMean` is added only for zero-order evaluation.
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
    % knotPoints = BSpline.knotPointsForDataPoints(t, S=3);
    % X = BSpline.matrix(t, knotPoints, 3);
    % spline = BSpline(S=3, knotPoints=knotPoints, xi=X\x);
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
    properties (SetAccess = private)
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
        % size(t_pp) = length(knotPoints) - 2*K + 1
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
        knotPoints
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
        function self = BSpline(options)
            % Create a one-dimensional spline from degree, knots, and coefficients.
            %
            % Use this constructor when you already know the terminated knot
            % sequence `knotPoints` and the coefficient vector `xi`.
            %
            % The constructed spline is
            %
            % $$
            % f(t) = x_{\mathrm{Mean}} + x_{\mathrm{Std}} \sum_{j=1}^{M} \xi_j B_{j,S}(t;\tau).
            % $$
            %
            % ```matlab
            % knotPoints = [0; 0; 0; 0; 1; 1; 1; 1];
            % xi = [1; -0.5; 0.25; 0];
            % spline = BSpline(S=3, knotPoints=knotPoints, xi=xi);
            % x = spline(linspace(0,1,50)');
            % ```
            %
            % - Topic: Create a spline
            % - Declaration: spline = BSpline(options)
            % - Parameter options.S: spline degree
            % - Parameter options.knotPoints: knot points
            % - Parameter options.xi: (optional) spline coefficients
            % - Parameter options.Xtpp: optional cached basis values at piecewise breakpoints
            % - Parameter options.xMean: optional additive output offset
            % - Parameter options.xStd: optional multiplicative output scale
            % - Returns spline: BSpline instance
            arguments
                options.S (1,1) double {mustBeInteger,mustBeNonnegative}
                options.knotPoints (:,1) double {mustBeNumeric,mustBeReal}
                options.xi {mustBeNumeric,mustBeReal,mustBeFinite} = []
                options.Xtpp (:,:,:) double = []
                options.xMean (1,1) double {mustBeReal,mustBeFinite} = 0
                options.xStd (1,1) double {mustBeReal,mustBeFinite} = 1
            end

            K = options.S + 1;
            knotPoints = options.knotPoints;
            if isempty(options.xi)
                xi = zeros(length(knotPoints) - K, 1);
            else
                xi = reshape(options.xi, [], 1);
            end

            self.K = K;
            self.tKnot_ = knotPoints;
            self.Xtpp = options.Xtpp;
            self.xMean = options.xMean;
            self.xStd = options.xStd;
            self.xi = xi;
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
            domain = [self.knotPoints(1) self.knotPoints(end)];
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
                xi {mustBeNumeric,mustBeReal,mustBeFinite}
            end
            xi = reshape(xi, [], 1);
            if ~isempty(xi) && numel(xi) ~= numel(self.tKnot_) - self.K
                error('BSpline:InvalidCoefficientCount', 'xi must contain exactly numel(knotPoints) - K coefficients.');
            end
            self.xi_ = xi;
            self.splineCoefficientsDidChange();
        end

        function knotPoints = get.knotPoints(self)
            % Return the current knot sequence.
            %
            % - Topic: Inspect spline properties
            % - Declaration: knotPoints = get.knotPoints(self)
            % - Parameter self: BSpline instance
            % - Returns knotPoints: knot vector
            knotPoints = self.tKnot_;
        end
        
        x_out = valueAtPoints(self, t, options)
        tKnotDidChange(self)
        splineCoefficientsDidChange(self)
    end

    methods (Access = private)
        transformedSpline = affineOutputTransform(self, scale, offset)
    end
    
    methods (Static)
        knotPoints = knotPointsForDataPoints(t, options)
        t = pointsOfSupport(knotPoints, S)
        [C,tpp,Xtpp] = ppCoefficientsFromSplineCoefficients(xi, knotPoints, S, options)
        f = evaluateFromPPCoefficients(t,C,tpp, D)
        B = matrix(t, knotPoints, S, options)
    end
end
