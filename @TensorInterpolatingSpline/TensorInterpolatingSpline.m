classdef TensorInterpolatingSpline < TensorSpline
    % Tensor-product interpolating spline on rectilinear grids.

    properties (SetAccess = private)
        gridVectors
    end

    methods
        function self = TensorInterpolatingSpline(gridVectors, values, options)
            arguments
                gridVectors cell
                values {mustBeNumeric,mustBeReal,mustBeFinite}
                options.K = 4
                options.S = NaN
            end

            numDimensions = numel(gridVectors);
            gridVectors = TensorInterpolatingSpline.normalizeGridVectors(gridVectors, numDimensions);
            K = TensorInterpolatingSpline.splineOrderFromOptions(options, numDimensions);
            TensorInterpolatingSpline.validateValueArraySize(values, gridVectors);

            tKnot = cell(1, numDimensions);
            for iDim = 1:numDimensions
                tKnot{iDim} = BSpline.knotPointsForDataPoints(gridVectors{iDim}, K=K(iDim));
            end

            xMean = mean(values(:));
            values = values - xMean;

            xStd = std(values(:));
            if xStd > 0
                values = values / xStd;
            else
                xStd = 1;
            end

            [gridPoints, ~] = TensorSpline.pointsFromGridVectors(gridVectors);
            basisMatrix = TensorSpline.matrix(gridPoints, tKnot, K);
            xi = basisMatrix \ values(:);

            self@TensorSpline(K, tKnot, xi, x_mean=xMean, x_std=xStd);
            self.gridVectors = gridVectors;
        end
    end

    methods (Static, Access = private)
        function K = splineOrderFromOptions(options, numDimensions)
            if isnan(options.S)
                K = options.K;
            else
                if ~(isscalar(options.K) && options.K == 4)
                    error('TensorInterpolatingSpline:ConflictingSplineOrder', 'Specify either K or S, but not both.');
                end
                K = options.S + 1;
            end

            K = TensorInterpolatingSpline.normalizeOrderVector(K, numDimensions);
        end

        function K = normalizeOrderVector(K, numDimensions)
            validateattributes(K, {'numeric'}, {'vector','real','finite','positive','integer'});
            if isscalar(K)
                K = repmat(K, 1, numDimensions);
            else
                K = reshape(K, 1, []);
                if numel(K) ~= numDimensions
                    error('TensorInterpolatingSpline:InvalidOrderVector', ...
                        'K must be scalar or have one element per dimension.');
                end
            end
        end

        function gridVectors = normalizeGridVectors(gridVectors, numDimensions)
            if ~iscell(gridVectors) || numel(gridVectors) ~= numDimensions
                error('TensorInterpolatingSpline:InvalidGridVectors', ...
                    'gridVectors must be a cell array with one vector per dimension.');
            end

            for iDim = 1:numDimensions
                validateattributes(gridVectors{iDim}, {'numeric'}, {'column','real','finite'});
                gridVectors{iDim} = reshape(gridVectors{iDim}, [], 1);
            end
        end

        function validateValueArraySize(values, gridVectors)
            expectedSize = cellfun(@numel, gridVectors);
            actualSize = size(values);
            actualSize = [actualSize, ones(1, numel(expectedSize) - numel(actualSize))];

            if ~isequal(actualSize(1:numel(expectedSize)), expectedSize)
                error('TensorInterpolatingSpline:SizeMismatch', ...
                    'values must have size matching the lengths of gridVectors.');
            end
        end
    end
end
