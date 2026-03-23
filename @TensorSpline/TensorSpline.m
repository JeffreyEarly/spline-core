classdef TensorSpline < handle
    % Tensor-product spline over multiple dimensions.
    %
    % TensorSpline represents a tensor-product basis assembled from
    % one-dimensional B-spline bases in each coordinate direction. It
    % supports direct evaluation on one query array per coordinate
    % together with mixed partial derivatives.
    %
    % ## Basic usage
    %
    % Use `TensorSpline` when you already have knot vectors and
    % tensor-product coefficients and want to evaluate the resulting
    % spline on query arrays.
    %
    % ```matlab
    % tKnot = {[0;0;0;0;1;1;1;1], [0;0;0;0;1;1;1;1]};
    % xi = randn(16,1);
    % spline = TensorSpline([4 4], tKnot, xi);
    %
    % xq = linspace(0,1,40)';
    % yq = linspace(0,1,40)';
    % F = spline(xq, yq);
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
        tKnot
        % Minimum and maximum values of the spline domain in each dimension.
        %
        % - Topic: Inspect spline properties
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
            % values = spline(xq, yq);
            % ```
            %
            % - Topic: Create a spline
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
                options.xMean (1,1) double {mustBeReal,mustBeFinite} = 0
                options.xStd (1,1) double {mustBeReal,mustBeFinite} = 1
            end

            numDimensions = numel(tKnot);
            K = TensorSpline.normalizeOrders(K, numDimensions);
            tKnot = TensorSpline.normalizeKnotCell(tKnot, numDimensions);
            basisSize = TensorSpline.basisSizeFromKnotCell(tKnot, K);

            if isempty(xi)
                xi = zeros(prod(basisSize),1);
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

        function value = get.tKnot(self)
            % Return the knot vectors defining the tensor-product basis.
            %
            % - Topic: Inspect spline properties
            % - Declaration: value = get.tKnot(self)
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

        function varargout = subsref(self, index)
            % Evaluate the tensor spline with function-call syntax or defer to built-in indexing.
            %
            % Use `spline(X1,...,Xn)` for values and
            % `spline(X1,...,Xn,D)` for mixed partial derivatives.
            %
            % ```matlab
            % values = spline(xq, yq);
            % dFdx = spline(xq, yq, [1 0]);
            % ```
            %
            % - Topic: Evaluate the spline
            % - Declaration: varargout = subsref(self,index)
            % - Parameter self: TensorSpline instance
            % - Parameter index: MATLAB subscript structure
            % - Returns varargout: indexed property access or spline values
            idx = index(1).subs;
            switch index(1).type
                case '()'
                    varargout{1} = self.valueAtPoints(idx{:});
                case '.'
                    [varargout{1:nargout}] = builtin('subsref',self,index);
                case '{}'
                    error('The TensorSpline class does not know what to do with {}.');
                otherwise
                    error('Unexpected syntax');
            end
        end

        function values = valueAtPoints(self, varargin)
            % Evaluate the tensor spline or a mixed partial derivative.
            %
            % Evaluate with one query input per tensor dimension.
            %
            % ```matlab
            % values = spline(xq, yq);
            % ```
            %
            % - Topic: Evaluate the spline
            % - Declaration: values = valueAtPoints(self,X1,...,Xn,derivativeOrders)
            % - Parameter self: TensorSpline instance
            % - Parameter X1,...,Xn: query locations as one array per dimension
            % - Parameter derivativeOrders: derivative order per dimension
            % - Returns values: spline values reshaped to match the query input

            if isempty(varargin)
                error('TensorSpline:NotEnoughInputs', 'Specify one query input per spline dimension.');
            end

            if numel(varargin) == self.numDimensions
                queryInputs = varargin;
                derivativeOrders = zeros(1, self.numDimensions);
            elseif numel(varargin) == self.numDimensions + 1
                queryInputs = varargin(1:end-1);
                derivativeOrders = TensorSpline.normalizeDerivativeOrders(varargin{end}, self.numDimensions);
            else
                error('TensorSpline:InvalidEvaluationInput', 'Use spline(X1,...,Xn) or spline(X1,...,Xn,D).');
            end

            [pointMatrix, outputSize] = TensorSpline.normalizeQueryInputs(queryInputs, self.numDimensions);

            if any(derivativeOrders > self.K - 1)
                values = zeros(outputSize, 'like', pointMatrix);
                return;
            end

            basisMatrix = TensorSpline.matrix(pointMatrix, self.tKnot_, self.K, D=derivativeOrders);
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
            % [Xq, Yq] = ndgrid(xq, yq);
            % B = TensorSpline.matrix([Xq(:), Yq(:)], tKnot, [4 4]);
            % values = B * spline.xi(:);
            % ```
            %
            % - Topic: Build spline bases
            % - Declaration: B = matrix(X,tKnot,K,options)
            % - Parameter X: query locations as a point matrix
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
            [pointMatrix, ~] = TensorSpline.normalizePointMatrixInput(X, numDimensions);
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
            % - Topic: Build spline bases
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

        function [pointMatrix, supportVectors] = pointsOfSupport(tKnot, K, D)
            % Return representative support points for a tensor-product spline basis.
            %
            % Use these points when you need one representative location per tensor
            % basis function, for example when constructing transformed splines from
            % sampled values.
            %
            % ```matlab
            % [supportPoints, supportVectors] = TensorSpline.pointsOfSupport(tKnot, [4 4]);
            % values = spline(supportVectors{:});
            % ```
            %
            % - Topic: Build spline bases
            % - Declaration: [pointMatrix,supportVectors] = pointsOfSupport(tKnot,K,D)
            % - Parameter tKnot: cell array of knot vectors
            % - Parameter K: spline order scalar or vector with one entry per dimension
            % - Parameter D: reserved derivative-order argument for API compatibility
            % - Returns pointMatrix: matrix with one row per tensor support point
            % - Returns supportVectors: cell array with one support vector per dimension
            arguments
                tKnot cell
                K {mustBeNumeric,mustBeReal,mustBeFinite}
                D (1,1) double {mustBeInteger,mustBeNonnegative} = 0
            end

            % D is reserved for API compatibility.
            numDimensions = numel(tKnot);
            K = TensorSpline.normalizeOrders(K, numDimensions);
            tKnot = TensorSpline.normalizeKnotCell(tKnot, numDimensions);

            supportVectors = cell(1, numDimensions);
            for iDim = 1:numDimensions
                supportVectors{iDim} = BSpline.pointsOfSupport(tKnot{iDim}, K(iDim), D);
            end

            pointMatrix = TensorSpline.pointsFromGridVectors(supportVectors);
        end
    end

    methods (Static, Hidden)
        function K = resolveSplineOrders(K, S, numDimensions, errorPrefix)
            % Resolve mutually exclusive spline order and degree inputs.
            if isempty(S) || (isscalar(S) && isnan(S))
                K = TensorSpline.normalizeOrders(K, numDimensions);
                return;
            end

            validateattributes(S, {'numeric'}, {'vector','real','finite','nonnegative','integer'});
            if ~(isscalar(K) && K == 4)
                error(errorPrefix + ":ConflictingSplineOrder",  'Specify either K or S, but not both.');
            end

            K = TensorSpline.normalizeOrders(S + 1, numDimensions);
        end

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

            tKnot = reshape(tKnot, 1, []);
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

        function [pointMatrix, outputSize] = normalizePointMatrixInput(X, numDimensions)
            % Normalize query locations from point-matrix form.
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

        function [pointMatrix, outputSize] = normalizeQueryInputs(queryInputs, numDimensions)
            % Normalize one query input per dimension.
            if numel(queryInputs) ~= numDimensions
                error('TensorSpline:InvalidEvaluationInput',  'Supply exactly one query input per spline dimension.');
            end

            validateattributes(queryInputs{1}, {'numeric'}, {'real'});
            outputSize = size(queryInputs{1});
            numPoints = numel(queryInputs{1});
            pointMatrix = zeros(numPoints, numDimensions);
            for iDim = 1:numDimensions
                validateattributes(queryInputs{iDim}, {'numeric'}, {'real'});
                if ~isequal(size(queryInputs{iDim}), outputSize)
                    error('TensorSpline:InvalidQueryArrays',  'All query inputs must have the same size.');
                end
                pointMatrix(:,iDim) = queryInputs{iDim}(:);
            end
        end

        function derivativeOrders = normalizeDerivativeOrders(derivativeOrders, numDimensions)
            % Normalize derivative-order input to one order per dimension.
            %
            % - Topic: Utility
            % - Developer: true
            % - Declaration: derivativeOrders = normalizeDerivativeOrders(derivativeOrders,numDimensions)
            validateattributes(derivativeOrders, {'numeric'}, {'real','finite','nonnegative','integer'});
            if isscalar(derivativeOrders)
                if numDimensions == 1
                    derivativeOrders = derivativeOrders;
                elseif derivativeOrders == 0
                    derivativeOrders = zeros(1, numDimensions);
                else
                    error('TensorSpline:InvalidDerivativeOrders',  'Derivative orders must be a vector with one element per dimension.');
                end
            else
                derivativeOrders = reshape(derivativeOrders, 1, []);
                if numel(derivativeOrders) ~= numDimensions
                    error('TensorSpline:InvalidDerivativeOrders',  'Derivative orders must have one element per dimension.');
                end
            end
        end

        function [xi, tKnot, K] = differentiateAlongDimension(xi, tKnot, K, derivativeOrder, dim)
            % Differentiate tensor coefficients along one dimension.
            %
            % - Topic: Utility
            % - Developer: true
            % - Declaration: [xi,tKnot,K] = differentiateAlongDimension(xi,tKnot,K,derivativeOrder,dim)
            perm = [dim, 1:(dim-1), (dim+1):ndims(xi)];
            xiPermuted = permute(xi, perm);
            xiMatrix = reshape(xiPermuted, size(xiPermuted, 1), []);

            originalK = K;
            originalTKnot = tKnot;
            transformedSlice = diff(BSpline(originalK, originalTKnot, xiMatrix(:,1)), derivativeOrder);
            tKnot = transformedSlice.tKnot;
            K = transformedSlice.K;

            transformedMatrix = zeros(numel(transformedSlice.xi), size(xiMatrix, 2), 'like', xiMatrix);
            transformedMatrix(:,1) = transformedSlice.xi;
            for iSlice = 2:size(xiMatrix, 2)
                transformedSlice = diff(BSpline(originalK, originalTKnot, xiMatrix(:,iSlice)), derivativeOrder);
                transformedMatrix(:,iSlice) = transformedSlice.xi;
            end

            outputSize = size(xiPermuted);
            outputSize(1) = size(transformedMatrix, 1);
            xi = ipermute(reshape(transformedMatrix, outputSize), perm);
        end

        function [xi, tKnot, K] = integrateAlongDimension(xi, tKnot, K, dim, xMean, xStd)
            % Integrate tensor coefficients along one dimension.
            %
            % - Topic: Utility
            % - Developer: true
            % - Declaration: [xi,tKnot,K] = integrateAlongDimension(xi,tKnot,K,dim,xMean,xStd)
            perm = [dim, 1:(dim-1), (dim+1):ndims(xi)];
            xiPermuted = permute(xi, perm);
            xiMatrix = reshape(xiPermuted, size(xiPermuted, 1), []);

            originalK = K;
            originalTKnot = tKnot;
            transformedSlice = cumsum(BSpline(originalK, originalTKnot, xiMatrix(:,1), xMean=xMean, xStd=xStd));
            tKnot = transformedSlice.tKnot;
            K = transformedSlice.K;

            transformedMatrix = zeros(numel(transformedSlice.xi), size(xiMatrix, 2), 'like', transformedSlice.xi);
            transformedMatrix(:,1) = transformedSlice.xi;
            for iSlice = 2:size(xiMatrix, 2)
                transformedSlice = cumsum(BSpline(originalK, originalTKnot, xiMatrix(:,iSlice), xMean=xMean, xStd=xStd));
                transformedMatrix(:,iSlice) = transformedSlice.xi;
            end

            outputSize = size(xiPermuted);
            outputSize(1) = size(transformedMatrix, 1);
            xi = ipermute(reshape(transformedMatrix, outputSize), perm);
        end

        function spline = zeroSplineForDomain(domain, numDimensions, options)
            % Create a zero spline over the supplied domain.
            %
            % - Topic: Utility
            % - Developer: true
            % - Declaration: spline = zeroSplineForDomain(domain,numDimensions,options)
            arguments
                domain (:,2) double {mustBeNumeric,mustBeReal,mustBeFinite}
                numDimensions (1,1) double {mustBeInteger,mustBePositive}
                options.xStd = 1
            end

            tKnot = cell(1, numDimensions);
            for iDim = 1:numDimensions
                tKnot{iDim} = reshape(domain(iDim,:), [], 1);
            end
            spline = TensorSpline(ones(1, numDimensions), tKnot, 0, xMean=0, xStd=options.xStd);
        end
    end

end
