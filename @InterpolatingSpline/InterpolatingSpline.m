classdef InterpolatingSpline < TensorSpline
    % Interpolating spline on one-dimensional samples or rectilinear grids.
    %
    % Supported construction forms:
    %   spline = InterpolatingSpline(x,V)
    %   spline = InterpolatingSpline({x,y,...},V)
    %   spline = InterpolatingSpline(grid,V,K=K)
    %   spline = InterpolatingSpline(grid,V,S=S)
    %
    % ## Basic usage
    %
    % Use `InterpolatingSpline` when you have values on one-dimensional
    % samples or a rectilinear grid and want a spline that matches them
    % exactly.
    %
    % ```matlab
    % [X,Y] = ndgrid(linspace(0,1,8), linspace(-1,1,9));
    % F = sin(2*pi*X).*cos(pi*Y);
    % spline = InterpolatingSpline({X(:,1), Y(1,:)}, F);
    % Fq = spline(X, Y);
    % ```
    %
    % - Topic: Create an interpolating spline
    % - Topic: Inspect interpolation grids
    % - Declaration: classdef InterpolatingSpline < TensorSpline

    properties (SetAccess = private)
        % Grid vectors used to define the interpolation lattice.
        %
        % - Topic: Inspect interpolation grids
        gridVectors
    end

    methods
        function self = InterpolatingSpline(grid, values, options)
            % Create an interpolating spline on one-dimensional samples or a rectilinear grid.
            %
            % Use this constructor when your data already live on a
            % rectilinear grid and should be reproduced exactly by the spline.
            % Supply a numeric vector in 1-D or a cell array of grid vectors
            % in higher dimensions together with the sampled value array.
            %
            % ```matlab
            % spline = InterpolatingSpline({x, y}, F, K=[4 4]);
            % Fq = spline(Xq, Yq);
            % ```
            %
            % - Topic: Create an interpolating spline
            % - Declaration: self = InterpolatingSpline(grid,values,options)
            % - Parameter grid: numeric vector in 1-D or cell array of grid vectors in higher dimensions
            % - Parameter values: array of sampled values on the grid
            % - Parameter options.K: spline order scalar or vector with one entry per dimension
            % - Parameter options.S: spline degree scalar or vector with one entry per dimension
            % - Returns self: InterpolatingSpline instance
            arguments
                grid
                values {mustBeNumeric,mustBeReal,mustBeFinite}
                options.K {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBePositive} = 4
                options.S {mustBeNumeric,mustBeReal} = []
            end

            if iscell(grid)
                if isempty(grid)
                    error('InterpolatingSpline:InvalidGrid', 'grid must not be empty.');
                end

                gridVectors = reshape(grid, 1, []);
                for iDim = 1:numel(gridVectors)
                    validateattributes(gridVectors{iDim}, {'numeric'}, {'vector','real','finite','nonempty'});
                    gridVectors{iDim} = reshape(gridVectors{iDim}, [], 1);
                end
            else
                validateattributes(grid, {'numeric'}, {'vector','real','finite','nonempty'});
                gridVectors = {reshape(grid, [], 1)};
            end

            numDimensions = numel(gridVectors);
            expectedSize = cellfun(@numel, gridVectors);
            if numDimensions == 1
                if ~(isvector(values) && numel(values) == expectedSize(1))
                    error('InterpolatingSpline:SizeMismatch', 'values must have size matching the lengths of the supplied grid inputs.');
                end
            else
                actualSize = size(values);
                if numel(actualSize) < numDimensions
                    actualSize = [actualSize, ones(1, numDimensions - numel(actualSize))];
                end

                if ~isequal(actualSize(1:numDimensions), expectedSize)
                    error('InterpolatingSpline:SizeMismatch', 'values must have size matching the lengths of the supplied grid inputs.');
                end
            end

            if isempty(options.S)
                K = options.K;
            else
                validateattributes(options.S, {'numeric'}, {'vector','real','finite','nonnegative','integer'});
                if ~(isscalar(options.K) && options.K == 4)
                    error('InterpolatingSpline:ConflictingSplineOrder', 'Specify either K or S, but not both.');
                end
                K = options.S + 1;
            end
            K = TensorSpline.normalizeOrders(K, numDimensions);

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
end
