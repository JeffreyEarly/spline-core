classdef TensorSpline < handle
    % Tensor-product spline over multiple dimensions.
    %
    % TensorSpline represents a tensor-product basis assembled from
    % one-dimensional B-spline bases in each coordinate direction. It
    % supports pointwise evaluation on one matching-size query array
    % per coordinate together with mixed partial derivatives.
    %
    % ## Basic usage
    %
    % Use `TensorSpline` when you already have knot vectors and
    % tensor-product coefficients and want to evaluate the resulting
    % spline on matching-size query arrays.
    %
    % ```matlab
    % knotPoints = {[0;0;0;0;1;1;1;1], [0;0;0;0;1;1;1;1]};
    % xi = randn(16,1);
    % spline = TensorSpline(S=[3 3], knotPoints=knotPoints, xi=xi);
    %
    % [Xq,Yq] = ndgrid(linspace(0,1,40), linspace(0,1,40));
    % F = spline(Xq, Yq);
    % ```
    %
    % - Topic: Create a spline
    % - Topic: Inspect spline properties
    % - Topic: Evaluate the spline
    % - Topic: Transform the spline
    % - Topic: Build spline bases
    % - Declaration: classdef TensorSpline < handle

    properties (SetAccess = private)
        % Spline order in each tensor dimension.
        %
        % - Topic: Inspect spline properties
        K
    end

    properties (Access = private)
        % Internal tensor-product spline coefficients reshaped to basisSize.
        xi_
        % Internal knot vectors for each tensor dimension.
        tKnot_
    end

    properties (Access = protected, Hidden)
        coefficientsAreReadOnly (1,1) logical = false
    end

    properties (SetAccess = private)
        % Mean added back to zero-order evaluations.
        %
        % - Topic: Inspect spline properties
        xMean (1,1) double {mustBeReal,mustBeFinite} = 0
        % Multiplicative scale applied to evaluations.
        %
        % - Topic: Inspect spline properties
        xStd (1,1) double {mustBeReal,mustBeFinite} = 1
    end

    properties (Dependent)
        % Polynomial degree in each tensor dimension.
        %
        % - Topic: Inspect spline properties
        S
        % Number of tensor dimensions.
        %
        % - Topic: Inspect spline properties
        numDimensions
        % Number of basis functions in each dimension.
        %
        % - Topic: Inspect spline properties
        basisSize
        % Tensor-product spline coefficients reshaped to basisSize.
        %
        % - Topic: Inspect spline properties
        xi
        % Knot vectors defining the spline basis.
        %
        % Returns a numeric vector in 1-D and a cell array in higher dimensions.
        %
        % - Topic: Inspect spline properties
        knotPoints
        % Minimum and maximum values of the spline domain in each dimension.
        %
        % - Topic: Inspect spline properties
        domain
    end

    methods
        function self = TensorSpline(options)
            % Create a tensor-product spline from per-dimension degrees, knots, and coefficients.
            %
            % Use this constructor when you already know the per-dimension
            % knot vectors and tensor-product coefficients.
            %
            % ```matlab
            % spline = TensorSpline(S=[3 3], knotPoints=knotPoints, xi=xi);
            % [Xq,Yq] = ndgrid(linspace(0,1,40), linspace(0,1,40));
            % values = spline(Xq, Yq);
            % ```
            %
            % - Topic: Create a spline
            % - Declaration: self = TensorSpline(options)
            % - Parameter options.S: spline degree scalar or vector with one entry per dimension
            % - Parameter options.knotPoints: knot vector in 1-D or cell array of knot vectors
            % - Parameter xi: optional tensor-product coefficient array or vector
            % - Parameter options.xMean: optional additive output offset
            % - Parameter options.xStd: optional multiplicative output scale
            % - Returns self: TensorSpline instance
            arguments
                options.S {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBeNonnegative}
                options.knotPoints
                options.xi {mustBeNumeric,mustBeReal,mustBeFinite} = []
                options.xMean (1,1) double {mustBeReal,mustBeFinite} = 0
                options.xStd (1,1) double {mustBeReal,mustBeFinite} = 1
            end

            if isnumeric(options.knotPoints)
                validateattributes(options.knotPoints, {'numeric'}, {'vector','real','finite','nonempty'});
                numDimensions = 1;
                tKnot = {reshape(options.knotPoints, [], 1)};
            else
                tKnot = options.knotPoints;
                numDimensions = numel(tKnot);
                tKnot = TensorSpline.normalizeKnotCell(tKnot, numDimensions);
            end

            K = TensorSpline.normalizeOrders(options.S + 1, numDimensions);
            basisSize = TensorSpline.basisSizeFromKnotCell(tKnot, K);

            if isempty(options.xi)
                xi = zeros(prod(basisSize),1);
            else
                xi = options.xi;
            end

            self.K = K;
            self.tKnot_ = tKnot;
            self.xi = xi;
            self.xMean = options.xMean;
            self.xStd = options.xStd;
        end

        function value = get.S(self)
            % Return the spline polynomial degree in each dimension.
            %
            % - Topic: Inspect spline properties
            % - Declaration: value = get.S(self)
            % - Parameter self: TensorSpline instance
            % - Returns value: row vector equal to K - 1
            value = self.K - 1;
        end

        function value = get.numDimensions(self)
            % Return the number of tensor dimensions.
            %
            % - Topic: Inspect spline properties
            % - Declaration: value = get.numDimensions(self)
            % - Parameter self: TensorSpline instance
            % - Returns value: number of dimensions
            value = numel(self.K);
        end

        function value = get.basisSize(self)
            % Return the number of basis functions per dimension.
            %
            % - Topic: Inspect spline properties
            % - Declaration: value = get.basisSize(self)
            % - Parameter self: TensorSpline instance
            % - Returns value: row vector of basis sizes
            value = TensorSpline.basisSizeFromKnotCell(self.tKnot_, self.K);
        end

        function value = get.xi(self)
            % Return the tensor-product spline coefficients.
            %
            % - Topic: Inspect spline properties
            % - Declaration: value = get.xi(self)
            % - Parameter self: TensorSpline instance
            % - Returns value: coefficient array reshaped to basisSize
            value = self.xi_;
        end

        function set.xi(self, value)
            % Update the tensor-product coefficients with canonical reshaping.
            %
            % - Topic: Inspect spline properties
            % - Declaration: set.xi(self,value)
            % - Parameter self: TensorSpline instance
            % - Parameter value: coefficient vector or array with prod(basisSize) entries
            arguments
                self (1,1) TensorSpline
                value {mustBeNumeric,mustBeReal,mustBeFinite}
            end

            if self.coefficientsAreReadOnly
                error('ConstrainedSpline:ReadOnlyCoefficients',  'Constrained spline coefficients are read-only after fitting.');
            end

            basisSize = self.basisSize;
            if numel(value) ~= prod(basisSize)
                error('TensorSpline:InvalidCoefficientCount',  'xi must contain exactly prod(basisSize) coefficients.');
            end

            if isscalar(basisSize)
                self.xi_ = reshape(value, basisSize, 1);
            else
                self.xi_ = reshape(value, basisSize);
            end
        end

        function value = get.knotPoints(self)
            % Return the knot vectors defining the tensor-product basis.
            %
            % - Topic: Inspect spline properties
            % - Declaration: value = get.knotPoints(self)
            % - Parameter self: TensorSpline instance
            % - Returns value: knot vector in 1-D, cell array otherwise
            if self.numDimensions == 1
                value = self.tKnot_{1};
            else
                value = self.tKnot_;
            end
        end

        function value = get.domain(self)
            % Return the domain limits for each dimension.
            %
            % - Topic: Inspect spline properties
            % - Declaration: value = get.domain(self)
            % - Parameter self: TensorSpline instance
            % - Returns value: numDimensions-by-2 array of [min max] domain limits
            value = cell2mat(cellfun(@(tk) [tk(1), tk(end)], self.tKnot_, 'UniformOutput', false)');
        end
        varargout = subsref(self, index)
        values = valueAtPoints(self, X, options)

    end

    methods (Static)
        B = matrix(X, knotPoints, S, options)
        [pointMatrix, gridSize] = pointsFromGridVectors(gridVectors)
        [pointMatrix, supportVectors] = pointsOfSupport(knotPoints, S)
    end

    methods (Static, Hidden)
        K = normalizeOrders(K, numDimensions)
        tKnot = normalizeKnotCell(tKnot, numDimensions)
        basisSize = basisSizeFromKnotCell(tKnot, K)
        derivativeOrders = normalizeDerivativeOrders(derivativeOrders, numDimensions)
        [xi, tKnot, K] = differentiateAlongDimension(xi, tKnot, K, derivativeOrder, dim)
        [xi, tKnot, K] = integrateAlongDimension(xi, tKnot, K, dim, xMean, xStd)
        spline = zeroSplineForDomain(domain, numDimensions, options)
    end

end
