classdef InterpolatingSpline < TensorSpline
    % Interpolating spline on one-dimensional samples or rectilinear grids.
    %
    % `InterpolatingSpline` is the exact-fit, grid-native specialization of
    % `TensorSpline`. Use it when your values are already sampled on a
    % one-dimensional grid or a rectilinear tensor grid and you want a
    % spline that reproduces those samples exactly.
    %
    % Supported construction forms:
    %   spline = InterpolatingSpline(x,V)
    %   spline = InterpolatingSpline({x,y,...},V)
    %   spline = InterpolatingSpline(grid,V,S=S)
    %
    % If $$\mathbf{B}$$ is the tensor-product basis matrix on the supplied
    % grid and $$\tilde{y}$$ is the normalized data vector, the stored
    % coefficients solve
    %
    % $$
    % \mathbf{B}\xi = \tilde{y}, \qquad
    % \tilde{y} = \frac{y - \bar{y}}{s_y},
    % $$
    %
    % where `xMean = \bar{y}` and `xStd = s_y` are stored so later
    % evaluation returns values on the original scale.
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
            % The implementation builds one knot vector per dimension from
            % the supplied grid vectors, standardizes the sampled values, and
            % solves the interpolation system
            %
            % $$
            % \mathbf{B}\xi = \tilde{y},
            % $$
            %
            % where $$\mathbf{B}$$ is the tensor-product basis matrix
            % evaluated on the grid points.
            %
            % ```matlab
            % x = linspace(0,1,8)';
            % y = linspace(-1,1,9)';
            % [X,Y] = ndgrid(x, y);
            % F = sin(2*pi*X).*cos(pi*Y);
            % spline = InterpolatingSpline({x, y}, F, S=[3 3]);
            % Fq = spline(X, Y);
            % ```
            %
            % - Topic: Create an interpolating spline
            % - Declaration: self = InterpolatingSpline(grid,values,options)
            % - Parameter grid: numeric vector in 1-D or cell array of grid vectors in higher dimensions
            % - Parameter values: array of sampled values on the grid
            % - Parameter options.S: spline degree scalar or vector with one entry per dimension
            % - Returns self: InterpolatingSpline instance
            arguments
                grid
                values {mustBeNumeric,mustBeReal,mustBeFinite}
                options.S {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBeNonnegative} = 3
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

            K = options.S + 1;
            K = TensorSpline.normalizeOrders(K, numDimensions);
            S = K - 1;

            tKnot = cell(1, numDimensions);
            for iDim = 1:numDimensions
                tKnot{iDim} = BSpline.knotPointsForDataPoints(gridVectors{iDim}, S=S(iDim));
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
            basisMatrix = TensorSpline.matrixForPointMatrix(gridPoints, knotPoints=tKnot, S=S);
            xi = basisMatrix \ values(:);

            self@TensorSpline(S=S, knotPoints=tKnot, xi=xi, xMean=xMean, xStd=xStd);
            self.gridVectors = gridVectors;
        end
    end
end
