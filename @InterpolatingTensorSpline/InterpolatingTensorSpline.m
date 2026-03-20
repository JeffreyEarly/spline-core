classdef InterpolatingTensorSpline < TensorSpline
    % Tensor-product interpolating spline on rectilinear grids.
    %
    % InterpolatingTensorSpline builds a tensor-product spline that exactly
    % interpolates data defined on a rectilinear grid in one or more
    % dimensions.
    %
    % ## Basic usage
    %
    % Use `InterpolatingTensorSpline` when you have values on a rectilinear
    % grid and want a tensor-product spline that matches them exactly.
    %
    % ```matlab
    % [X,Y] = ndgrid(linspace(0,1,8), linspace(-1,1,9));
    % F = sin(2*pi*X).*cos(pi*Y);
    % spline = InterpolatingTensorSpline({X(:,1), Y(1,:)'}, F);
    % Fq = spline({X,Y});
    % ```
    %
    % - Topic: Create an interpolating tensor spline
    % - Topic: Inspect interpolation grids
    % - Declaration: classdef InterpolatingTensorSpline < TensorSpline

    properties (SetAccess = private)
        % Grid vectors used to define the interpolation lattice.
        %
        % - Topic: Inspect interpolation grids
        gridVectors
    end

    methods
        function self = InterpolatingTensorSpline(gridVectors, values, options)
            % Create a tensor-product interpolating spline on a rectilinear grid.
            %
            % Use this constructor when your data already live on a
            % rectilinear grid and should be reproduced exactly by the
            % spline.
            %
            % ```matlab
            % spline = InterpolatingTensorSpline({x,y}, F, K=[4 4]);
            % Fq = spline({Xq,Yq});
            % ```
            %
            % - Topic: Create an interpolating tensor spline
            % - Declaration: self = InterpolatingTensorSpline(gridVectors,values,options)
            % - Parameter gridVectors: cell array of grid vectors, one per dimension
            % - Parameter values: array of sampled values on the grid
            % - Parameter options.K: spline order scalar or vector with one entry per dimension
            % - Parameter options.S: spline degree scalar or vector with one entry per dimension
            % - Returns self: InterpolatingTensorSpline instance
            arguments
                gridVectors cell
                values {mustBeNumeric,mustBeReal,mustBeFinite}
                options.K = 4
                options.S = NaN
            end

            numDimensions = numel(gridVectors);
            gridVectors = InterpolatingTensorSpline.normalizeGridVectors(gridVectors, numDimensions);
            K = InterpolatingTensorSpline.splineOrderFromOptions(options, numDimensions);
            InterpolatingTensorSpline.validateValueArraySize(values, gridVectors);

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

            self@TensorSpline(K, tKnot, xi, xMean=xMean, xStd=xStd);
            self.gridVectors = gridVectors;
        end
    end

    methods (Static, Access = private)
        function K = splineOrderFromOptions(options, numDimensions)
            % Resolve spline order from mutually exclusive K and S options.
            if isnan(options.S)
                K = options.K;
            else
                if ~(isscalar(options.K) && options.K == 4)
                    error('InterpolatingTensorSpline:ConflictingSplineOrder', 'Specify either K or S, but not both.');
                end
                K = options.S + 1;
            end

            K = InterpolatingTensorSpline.normalizeOrderVector(K, numDimensions);
        end

        function K = normalizeOrderVector(K, numDimensions)
            % Normalize spline-order input to one order per dimension.
            validateattributes(K, {'numeric'}, {'vector','real','finite','positive','integer'});
            if isscalar(K)
                K = repmat(K, 1, numDimensions);
            else
                K = reshape(K, 1, []);
                if numel(K) ~= numDimensions
                    error('InterpolatingTensorSpline:InvalidOrderVector', ...
                        'K must be scalar or have one element per dimension.');
                end
            end
        end

        function gridVectors = normalizeGridVectors(gridVectors, numDimensions)
            % Normalize and validate interpolation grid vectors.
            if ~iscell(gridVectors) || numel(gridVectors) ~= numDimensions
                error('InterpolatingTensorSpline:InvalidGridVectors', ...
                    'gridVectors must be a cell array with one vector per dimension.');
            end

            for iDim = 1:numDimensions
                validateattributes(gridVectors{iDim}, {'numeric'}, {'column','real','finite'});
                gridVectors{iDim} = reshape(gridVectors{iDim}, [], 1);
            end
        end

        function validateValueArraySize(values, gridVectors)
            % Validate that the sample array matches the supplied grid vectors.
            expectedSize = cellfun(@numel, gridVectors);
            actualSize = size(values);
            actualSize = [actualSize, ones(1, numel(expectedSize) - numel(actualSize))];

            if ~isequal(actualSize(1:numel(expectedSize)), expectedSize)
                error('InterpolatingTensorSpline:SizeMismatch', ...
                    'values must have size matching the lengths of gridVectors.');
            end
        end
    end
end
