classdef TensorSpline < handle
    % Tensor-product spline over multiple dimensions.

    properties (SetAccess = private)
        K
        tKnot
        xi
    end

    properties
        x_mean = 0
        x_std = 1
    end

    properties (Dependent)
        numDimensions
        basisSize
        domain
    end

    methods
        function self = TensorSpline(K,tKnot,xi,options)
            arguments
                K {mustBeNumeric,mustBeReal,mustBeFinite}
                tKnot cell
                xi = []
                options.x_mean = 0
                options.x_std = 1
            end

            numDimensions = numel(tKnot);
            K = TensorSpline.normalizeOrders(K, numDimensions);
            tKnot = TensorSpline.normalizeKnotCell(tKnot, numDimensions);
            basisSize = TensorSpline.basisSizeFromKnotCell(tKnot, K);

            if isempty(xi)
                xi = zeros(prod(basisSize),1);
            end

            validateattributes(xi, {'numeric'}, {'real','finite','numel',prod(basisSize)});

            self.K = K;
            self.tKnot = tKnot;
            self.xi = reshape(xi, basisSize);
            self.x_mean = options.x_mean;
            self.x_std = options.x_std;
        end

        function value = get.numDimensions(self)
            value = numel(self.K);
        end

        function value = get.basisSize(self)
            value = TensorSpline.basisSizeFromKnotCell(self.tKnot, self.K);
        end

        function value = get.domain(self)
            value = cellfun(@(tk) [tk(1), tk(end)], self.tKnot, 'UniformOutput', false);
        end

        function varargout = subsref(self, index)
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

            if ~isempty(self.x_std)
                values = self.x_std * values;
            end

            if ~isempty(self.x_mean) && all(derivativeOrders == 0)
                values = values + self.x_mean;
            end

            values = reshape(values, outputSize);
        end
    end

    methods (Static)
        function B = matrix(X,tKnot,K,options)
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
            if ~iscell(tKnot) || numel(tKnot) ~= numDimensions
                error('TensorSpline:InvalidKnotCell', 'tKnot must be a cell array with one knot vector per dimension.');
            end

            for iDim = 1:numDimensions
                validateattributes(tKnot{iDim}, {'numeric'}, {'column','real','finite'});
                tKnot{iDim} = reshape(tKnot{iDim}, [], 1);
            end
        end

        function basisSize = basisSizeFromKnotCell(tKnot, K)
            basisSize = cellfun(@numel, tKnot) - K;
            if any(basisSize <= 0)
                error('TensorSpline:InvalidBasisSize', 'Each knot vector must be longer than its spline order.');
            end
        end

        function [pointMatrix, outputSize] = normalizePointInput(X, numDimensions)
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
