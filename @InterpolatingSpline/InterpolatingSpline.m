classdef InterpolatingSpline < TensorSpline
    % Interpolating spline on one-dimensional samples or rectilinear grids.
    %
    % Supported construction forms:
    %   spline = InterpolatingSpline(x1,...,xn,V)
    %   spline = InterpolatingSpline(x1,...,xn,V,K=K)
    %   spline = InterpolatingSpline(x1,...,xn,V,S=S)
    %
    % The grid inputs are vectors, one per dimension.
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
    % spline = InterpolatingSpline(X(:,1), Y(1,:), F);
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
        function self = InterpolatingSpline(varargin)
            % Create an interpolating spline on one-dimensional samples or a rectilinear grid.
            %
            % Use this constructor when your data already live on a
            % rectilinear grid and should be reproduced exactly by the
            % spline. Supply one grid input per dimension followed by the
            % sampled value array.
            %
            % ```matlab
            % spline = InterpolatingSpline(x, y, F, K=[4 4]);
            % Fq = spline(Xq, Yq);
            % ```
            %
            % - Topic: Create an interpolating spline
            % - Declaration: self = InterpolatingSpline(X1,...,Xn,values,options)
            % - Parameter X1,...,Xn: grid vectors, one per dimension
            % - Parameter values: array of sampled values on the grid
            % - Parameter options.K: spline order scalar or vector with one entry per dimension
            % - Parameter options.S: spline degree scalar or vector with one entry per dimension
            % - Returns self: InterpolatingSpline instance
            firstNameValue = numel(varargin) + 1;
            for iInput = 1:numel(varargin)
                value = varargin{iInput};
                if (ischar(value) && isrow(value)) || (isstring(value) && isscalar(value))
                    firstNameValue = iInput;
                    break;
                end
            end

            positionalInputs = varargin(1:firstNameValue-1);
            if numel(positionalInputs) < 2
                error('InterpolatingSpline:NotEnoughInputs',  'Specify one or more grid inputs followed by the sampled values.');
            end

            gridVectors = positionalInputs(1:end-1);
            values = positionalInputs{end};
            validateattributes(values, {'numeric'}, {'real','finite'});

            numDimensions = numel(gridVectors);
            for iDim = 1:numDimensions
                validateattributes(gridVectors{iDim}, {'numeric'}, {'vector','real','finite'});
                gridVectors{iDim} = reshape(gridVectors{iDim}, [], 1);
            end

            K = 4;
            S = NaN;
            nameValueInputs = varargin(firstNameValue:end);
            if mod(numel(nameValueInputs), 2) ~= 0
                error('InterpolatingSpline:InvalidOptions',  'Name-value arguments must come in pairs.');
            end

            for iInput = 1:2:numel(nameValueInputs)
                name = nameValueInputs{iInput};
                if ~(ischar(name) && isrow(name)) && ~(isstring(name) && isscalar(name))
                    error('InterpolatingSpline:InvalidOptions',  'Option names must be text scalars.');
                end

                switch string(name)
                    case "K"
                        K = nameValueInputs{iInput + 1};
                    case "S"
                        S = nameValueInputs{iInput + 1};
                    otherwise
                        error('InterpolatingSpline:InvalidOptions',  'Unsupported option name "%s".', string(name));
                end
            end

            K = TensorSpline.resolveSplineOrders(K, S, numDimensions, "InterpolatingSpline");

            expectedSize = cellfun(@numel, gridVectors);
            if numel(expectedSize) == 1
                if ~(isvector(values) && numel(values) == expectedSize(1))
                    error('InterpolatingSpline:SizeMismatch',  'values must have size matching the lengths of the supplied grid inputs.');
                end
            else
                actualSize = size(values);
                if numel(actualSize) < numel(expectedSize)
                    actualSize = [actualSize, ones(1, numel(expectedSize) - numel(actualSize))];
                end

                if ~isequal(actualSize(1:numel(expectedSize)), expectedSize)
                    error('InterpolatingSpline:SizeMismatch',  'values must have size matching the lengths of the supplied grid inputs.');
                end
            end

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
