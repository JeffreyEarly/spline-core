classdef TensorSpline < handle
    % Tensor-product spline over multiple dimensions.
    %
    % TensorSpline represents a tensor-product basis assembled from
    % one-dimensional B-spline bases in each coordinate direction. It
    % supports direct evaluation on point clouds or query grids together
    % with mixed partial derivatives.
    %
    % ## Basic usage
    %
    % Use `TensorSpline` when you already have knot vectors and
    % tensor-product coefficients and want to evaluate the resulting
    % spline on points or grids.
    %
    % ```matlab
    % tKnot = {[0;0;0;0;1;1;1;1], [0;0;0;0;1;1;1;1]};
    % xi = randn(16,1);
    % spline = TensorSpline([4 4], tKnot, xi);
    %
    % [X,Y] = ndgrid(linspace(0,1,40), linspace(0,1,50));
    % F = spline({X,Y});
    % ```
    %
    % - Topic: Create a tensor spline
    % - Topic: Inspect tensor spline properties
    % - Topic: Evaluate the tensor spline
    % - Topic: Build tensor spline bases
    % - Declaration: classdef TensorSpline < handle

    properties (SetAccess = private)
        % Spline order in each tensor dimension.
        %
        % - Topic: Inspect tensor spline properties
        K
        % Knot vectors for each tensor dimension.
        %
        % - Topic: Inspect tensor spline properties
        tKnot
        % Tensor-product spline coefficients reshaped to basisSize.
        %
        % - Topic: Inspect tensor spline properties
        xi
    end

    properties
        % Mean added back to zero-order evaluations.
        %
        % - Topic: Inspect tensor spline properties
        xMean = 0
        % Multiplicative scale applied to evaluations.
        %
        % - Topic: Inspect tensor spline properties
        xStd = 1
    end

    properties (Dependent)
        % Number of tensor dimensions.
        %
        % - Topic: Inspect tensor spline properties
        numDimensions
        % Number of basis functions in each dimension.
        %
        % - Topic: Inspect tensor spline properties
        basisSize
        % Coordinate limits for each dimension.
        %
        % - Topic: Inspect tensor spline properties
        domain
    end

    methods
        function self = TensorSpline(K,tKnot,xi,options)
            % Create a tensor-product spline from per-dimension orders, knots, and coefficients.
            %
            % Use this constructor when you already know the per-dimension
            % knot vectors and tensor-product coefficients.
            %
            % ```matlab
            % spline = TensorSpline([4 4], tKnot, xi);
            % values = spline(queryPoints);
            % ```
            %
            % - Topic: Create a tensor spline
            % - Declaration: self = TensorSpline(K,tKnot,xi,options)
            % - Parameter K: spline order scalar or vector with one entry per dimension
            % - Parameter tKnot: cell array of knot vectors
            % - Parameter xi: optional tensor-product coefficient array or vector
            % - Parameter options.xMean: optional additive output offset
            % - Parameter options.xStd: optional multiplicative output scale
            % - Returns self: TensorSpline instance
            arguments
                K {mustBeNumeric,mustBeReal,mustBeFinite}
                tKnot cell
                xi = []
                options.xMean = 0
                options.xStd = 1
            end

            numDimensions = numel(tKnot);
            K = TensorSpline.normalizeOrders(K, numDimensions);
            tKnot = TensorSpline.normalizeKnotCell(tKnot, numDimensions);
            basisSize = TensorSpline.basisSizeFromKnotCell(tKnot, K);

            if isempty(xi)
                xi = zeros(prod(basisSize),1);
            end

            validateattributes(xi, {'numeric'}, {'real','finite'});
            if numel(xi) ~= prod(basisSize)
                error('TensorSpline:InvalidCoefficientCount', ...
                    'xi must contain exactly prod(basisSize) coefficients.');
            end

            self.K = K;
            self.tKnot = tKnot;
            if isscalar(basisSize)
                self.xi = reshape(xi, basisSize, 1);
            else
                self.xi = reshape(xi, basisSize);
            end
            self.xMean = options.xMean;
            self.xStd = options.xStd;
        end

        function value = get.numDimensions(self)
            % Return the number of tensor dimensions.
            %
            % - Topic: Inspect tensor spline properties
            % - Declaration: value = get.numDimensions(self)
            % - Parameter self: TensorSpline instance
            % - Returns value: number of dimensions
            value = numel(self.K);
        end

        function value = get.basisSize(self)
            % Return the number of basis functions per dimension.
            %
            % - Topic: Inspect tensor spline properties
            % - Declaration: value = get.basisSize(self)
            % - Parameter self: TensorSpline instance
            % - Returns value: row vector of basis sizes
            value = TensorSpline.basisSizeFromKnotCell(self.tKnot, self.K);
        end

        function value = get.domain(self)
            % Return the domain limits for each dimension.
            %
            % - Topic: Inspect tensor spline properties
            % - Declaration: value = get.domain(self)
            % - Parameter self: TensorSpline instance
            % - Returns value: cell array of [min max] domain limits
            value = cellfun(@(tk) [tk(1), tk(end)], self.tKnot, 'UniformOutput', false);
        end

        function varargout = subsref(self, index)
            % Evaluate the tensor spline with function-call syntax or defer to built-in indexing.
            %
            % Use `spline(X)` for values and `spline(X,D)` for mixed
            % partial derivatives.
            %
            % ```matlab
            % values = spline(queryPoints);
            % dFdx = spline(queryPoints, [1 0]);
            % ```
            %
            % - Topic: Evaluate the tensor spline
            % - Declaration: varargout = subsref(self,index)
            % - Parameter self: TensorSpline instance
            % - Parameter index: MATLAB subscript structure
            % - Returns varargout: indexed property access or spline values
            idx = index(1).subs;
            switch index(1).type
                case '()'
                    if numel(idx) >= 1
                        X = idx{1};
                    end

                    if numel(idx) >= 2
                        derivativeOrders = idx{2};
                    else
                        derivativeOrders = 0;
                    end

                    varargout{1} = self.valueAtPoints(X, derivativeOrders);
                case '.'
                    [varargout{1:nargout}] = builtin('subsref',self,index);
                case '{}'
                    error('The TensorSpline class does not know what to do with {}.');
                otherwise
                    error('Unexpected syntax');
            end
        end

        function values = valueAtPoints(self, X, derivativeOrders)
            % Evaluate the tensor spline or a mixed partial derivative.
            %
            % Evaluate either on an `N x D` point matrix or on a cell array
            % of matching query grids.
            %
            % ```matlab
            % values = spline(queryPoints);
            % valuesOnGrid = spline({X,Y});
            % ```
            %
            % - Topic: Evaluate the tensor spline
            % - Declaration: values = valueAtPoints(self,X,derivativeOrders)
            % - Parameter self: TensorSpline instance
            % - Parameter X: query locations as a point matrix or cell array of matching grids
            % - Parameter derivativeOrders: derivative order per dimension
            % - Returns values: spline values reshaped to match the query input
            arguments
                self (1,1) TensorSpline
                X
                derivativeOrders = 0
            end

            [pointMatrix, outputSize] = TensorSpline.normalizePointInput(X, self.numDimensions);
            derivativeOrders = TensorSpline.normalizeDerivativeOrders(derivativeOrders, self.numDimensions);

            if any(derivativeOrders > self.K - 1)
                values = zeros(outputSize, 'like', pointMatrix);
                return;
            end

            basisMatrix = TensorSpline.matrix(pointMatrix, self.tKnot, self.K, D=derivativeOrders);
            values = basisMatrix * self.xi(:);

            if ~isempty(self.xStd)
                values = self.xStd * values;
            end

            if ~isempty(self.xMean) && all(derivativeOrders == 0)
                values = values + self.xMean;
            end

            values = reshape(values, outputSize);
        end
    end

    methods (Static)
        function B = matrix(X,tKnot,K,options)
            % Evaluate the tensor-product basis matrix and optional derivatives.
            %
            % Use this to assemble a tensor-product design matrix for
            % interpolation, regression, or basis inspection.
            %
            % ```matlab
            % B = TensorSpline.matrix(queryPoints, tKnot, [4 4]);
            % values = B * spline.xi(:);
            % ```
            %
            % - Topic: Build tensor spline bases
            % - Declaration: B = matrix(X,tKnot,K,options)
            % - Parameter X: query locations as a point matrix or cell array of matching grids
            % - Parameter tKnot: cell array of knot vectors
            % - Parameter K: spline order scalar or vector with one entry per dimension
            % - Parameter options.D: derivative order per dimension
            % - Returns B: basis matrix with one row per query point
            arguments
                X
                tKnot cell
                K {mustBeNumeric,mustBeReal,mustBeFinite}
                options.D = 0
            end

            numDimensions = numel(tKnot);
            [pointMatrix, ~] = TensorSpline.normalizePointInput(X, numDimensions);
            K = TensorSpline.normalizeOrders(K, numDimensions);
            tKnot = TensorSpline.normalizeKnotCell(tKnot, numDimensions);
            derivativeOrders = TensorSpline.normalizeDerivativeOrders(options.D, numDimensions);
            basisSize = TensorSpline.basisSizeFromKnotCell(tKnot, K);

            if any(derivativeOrders > K - 1)
                B = zeros(size(pointMatrix,1), prod(basisSize));
                return;
            end

            numPoints = size(pointMatrix,1);
            dimensionMatrices = cell(1, numDimensions);
            for iDim = 1:numDimensions
                Bi = BSpline.matrix(pointMatrix(:,iDim), tKnot{iDim}, K(iDim), D=derivativeOrders(iDim));
                dimensionMatrices{iDim} = reshape(Bi(:,:,derivativeOrders(iDim)+1), numPoints, []);
            end

            B = dimensionMatrices{1};
            for iDim = 2:numDimensions
                previousBasis = B;
                currentBasis = dimensionMatrices{iDim};
                combinedBasis = zeros(numPoints, size(previousBasis,2) * size(currentBasis,2));
                for iPoint = 1:numPoints
                    combinedBasis(iPoint,:) = kron(currentBasis(iPoint,:), previousBasis(iPoint,:));
                end
                B = combinedBasis;
            end
        end

        function [pointMatrix, gridSize] = pointsFromGridVectors(gridVectors)
            % Convert rectilinear grid vectors into an explicit point matrix.
            %
            % Use this helper to convert rectilinear grid vectors into the
            % point-matrix format accepted by `TensorSpline.matrix`.
            %
            % ```matlab
            % [points, gridSize] = TensorSpline.pointsFromGridVectors({x,y});
            % B = TensorSpline.matrix(points, tKnot, [4 4]);
            % ```
            %
            % - Topic: Build tensor spline bases
            % - Declaration: [pointMatrix,gridSize] = pointsFromGridVectors(gridVectors)
            % - Parameter gridVectors: cell array of grid vectors
            % - Returns pointMatrix: matrix with one row per grid point
            % - Returns gridSize: number of points along each dimension
            arguments
                gridVectors cell
            end

            numDimensions = numel(gridVectors);
            gridVectors = TensorSpline.normalizeKnotCell(gridVectors, numDimensions);
            gridSize = cellfun(@numel, gridVectors);

            grids = cell(1, numDimensions);
            [grids{:}] = ndgrid(gridVectors{:});

            pointMatrix = zeros(prod(gridSize), numDimensions);
            for iDim = 1:numDimensions
                pointMatrix(:,iDim) = grids{iDim}(:);
            end
        end
    end

    methods (Static, Access = private)
        function K = normalizeOrders(K, numDimensions)
            % Normalize spline-order input to one order per dimension.
            validateattributes(K, {'numeric'}, {'vector','real','finite','positive','integer'});
            if isscalar(K)
                K = repmat(K, 1, numDimensions);
            else
                K = reshape(K, 1, []);
                if numel(K) ~= numDimensions
                    error('TensorSpline:InvalidOrderVector', 'K must be scalar or have one element per dimension.');
                end
            end
        end

        function tKnot = normalizeKnotCell(tKnot, numDimensions)
            % Normalize and validate a cell array of knot vectors.
            if ~iscell(tKnot) || numel(tKnot) ~= numDimensions
                error('TensorSpline:InvalidKnotCell', 'tKnot must be a cell array with one knot vector per dimension.');
            end

            for iDim = 1:numDimensions
                validateattributes(tKnot{iDim}, {'numeric'}, {'column','real','finite'});
                tKnot{iDim} = reshape(tKnot{iDim}, [], 1);
            end
        end

        function basisSize = basisSizeFromKnotCell(tKnot, K)
            % Compute basis sizes from knot vectors and spline orders.
            basisSize = reshape(cellfun(@numel, tKnot), 1, []) - reshape(K, 1, []);
            if any(basisSize <= 0)
                error('TensorSpline:InvalidBasisSize', 'Each knot vector must be longer than its spline order.');
            end
        end

        function [pointMatrix, outputSize] = normalizePointInput(X, numDimensions)
            % Normalize query locations from point-matrix or grid-cell form.
            if iscell(X)
                if numel(X) ~= numDimensions
                    error('TensorSpline:InvalidPointCell', 'Cell input must have one array per dimension.');
                end

                outputSize = size(X{1});
                pointMatrix = zeros(numel(X{1}), numDimensions);
                for iDim = 1:numDimensions
                    validateattributes(X{iDim}, {'numeric'}, {'real'});
                    if ~isequal(size(X{iDim}), outputSize)
                        error('TensorSpline:InvalidPointCell', 'All query arrays must have the same size.');
                    end
                    pointMatrix(:,iDim) = X{iDim}(:);
                end
                return;
            end

            validateattributes(X, {'numeric'}, {'real'});
            if numDimensions == 1
                outputSize = size(X);
                pointMatrix = reshape(X, [], 1);
            else
                if size(X,2) ~= numDimensions
                    error('TensorSpline:InvalidPointMatrix', 'Point matrix must have one column per dimension.');
                end
                outputSize = [size(X,1), 1];
                pointMatrix = X;
            end
        end

        function derivativeOrders = normalizeDerivativeOrders(derivativeOrders, numDimensions)
            % Normalize derivative-order input to one order per dimension.
            validateattributes(derivativeOrders, {'numeric'}, {'real','finite','nonnegative','integer'});
            if isscalar(derivativeOrders)
                if numDimensions == 1
                    derivativeOrders = derivativeOrders;
                elseif derivativeOrders == 0
                    derivativeOrders = zeros(1, numDimensions);
                else
                    error('TensorSpline:InvalidDerivativeOrders', ...
                        'Derivative orders must be a vector with one element per dimension.');
                end
            else
                derivativeOrders = reshape(derivativeOrders, 1, []);
                if numel(derivativeOrders) ~= numDimensions
                    error('TensorSpline:InvalidDerivativeOrders', ...
                        'Derivative orders must have one element per dimension.');
                end
            end
        end
    end
end
