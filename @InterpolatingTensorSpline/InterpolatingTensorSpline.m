classdef InterpolatingTensorSpline < TensorSpline
    % Tensor-product interpolating spline on rectilinear grids.
    %
    % Supported construction forms:
    %   spline = InterpolatingTensorSpline(x1,...,xn,V)
    %   spline = InterpolatingTensorSpline(x1,...,xn,V,K=K)
    %   spline = InterpolatingTensorSpline(x1,...,xn,V,S=S)
    %
    % The grid inputs are vectors, one per dimension.
    %
    % ## Basic usage
    %
    % Use `InterpolatingTensorSpline` when you have values on a rectilinear
    % grid and want a tensor-product spline that matches them exactly.
    %
    % ```matlab
    % [X,Y] = ndgrid(linspace(0,1,8), linspace(-1,1,9));
    % F = sin(2*pi*X).*cos(pi*Y);
    % spline = InterpolatingTensorSpline(X(:,1), Y(1,:), F);
    % Fq = spline(X, Y);
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
        function self = InterpolatingTensorSpline(varargin)
            % Create a tensor-product interpolating spline on a rectilinear grid.
            %
            % Use this constructor when your data already live on a
            % rectilinear grid and should be reproduced exactly by the
            % spline. Supply one grid input per dimension followed by the
            % sampled value array.
            %
            % ```matlab
            % spline = InterpolatingTensorSpline(x, y, F, K=[4 4]);
            % Fq = spline(Xq, Yq);
            % ```
            %
            % - Topic: Create an interpolating tensor spline
            % - Declaration: self = InterpolatingTensorSpline(X1,...,Xn,values,options)
            % - Parameter X1,...,Xn: grid vectors, one per dimension
            % - Parameter values: array of sampled values on the grid
            % - Parameter options.K: spline order scalar or vector with one entry per dimension
            % - Parameter options.S: spline degree scalar or vector with one entry per dimension
            % - Returns self: InterpolatingTensorSpline instance
            [gridVectors, values, options] = InterpolatingTensorSpline.parseConstructorInputs(varargin{:});

            numDimensions = numel(gridVectors);
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
        function [gridVectors, values, options] = parseConstructorInputs(varargin)
            % Parse constructor inputs into grid vectors, values, and options.
            firstNameValue = InterpolatingTensorSpline.firstNameValueIndex(varargin);
            positionalInputs = varargin(1:firstNameValue-1);
            nameValueInputs = varargin(firstNameValue:end);
            [gridInputs, values] = InterpolatingTensorSpline.parsePositionalInputs(positionalInputs{:});
            options = InterpolatingTensorSpline.parseNameValueOptions(nameValueInputs{:});
            gridVectors = InterpolatingTensorSpline.normalizeConstructorGridInputs(gridInputs, values);
        end

        function [gridInputs, values] = parsePositionalInputs(varargin)
            % Parse required positional inputs into grids and sampled values.
            if numel(varargin) < 2
                error('InterpolatingTensorSpline:NotEnoughInputs', ...
                    'Specify one or more grid inputs followed by the sampled values.');
            end

            gridInputs = varargin(1:end-1);
            values = InterpolatingTensorSpline.parseValues(varargin{end});
        end

        function firstNameValue = firstNameValueIndex(inputs)
            % Return the index where trailing name-value pairs begin.
            firstNameValue = numel(inputs) + 1;
            for iInput = 1:numel(inputs)
                if InterpolatingTensorSpline.isNameLike(inputs{iInput})
                    firstNameValue = iInput;
                    return;
                end
            end
        end

        function tf = isNameLike(value)
            % True for scalar text values that can name a trailing option.
            tf = (ischar(value) && isrow(value)) || (isstring(value) && isscalar(value));
        end

        function values = parseValues(values)
            % Validate sampled values.
            arguments
                values {mustBeNumeric,mustBeReal,mustBeFinite}
            end
        end

        function options = parseNameValueOptions(options)
            % Parse constructor name-value options.
            arguments
                options.K = 4
                options.S = NaN
            end
        end

        function gridVectors = normalizeConstructorGridInputs(gridInputs, values)
            % Normalize constructor grid inputs from vectors.
            numDimensions = numel(gridInputs);
            if ~all(cellfun(@isvector, gridInputs))
                error('InterpolatingTensorSpline:InvalidGridInputs', ...
                    'Grid inputs must be vectors, one per dimension.');
            end

            gridVectors = InterpolatingTensorSpline.normalizeGridVectors(gridInputs, numDimensions);
        end

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
                    'Grid inputs must supply one vector per dimension.');
            end

            for iDim = 1:numDimensions
                validateattributes(gridVectors{iDim}, {'numeric'}, {'vector','real','finite'});
                gridVectors{iDim} = reshape(gridVectors{iDim}, [], 1);
            end
        end

        function validateValueArraySize(values, gridVectors)
            % Validate that the sample array matches the supplied grid vectors.
            expectedSize = cellfun(@numel, gridVectors);
            if numel(expectedSize) == 1
                if ~(isvector(values) && numel(values) == expectedSize(1))
                    error('InterpolatingTensorSpline:SizeMismatch', ...
                        'values must have size matching the lengths of the supplied grid inputs.');
                end
                return;
            end

            actualSize = size(values);
            if numel(actualSize) < numel(expectedSize)
                actualSize = [actualSize, ones(1, numel(expectedSize) - numel(actualSize))];
            end

            if ~isequal(actualSize(1:numel(expectedSize)), expectedSize)
                error('InterpolatingTensorSpline:SizeMismatch', ...
                    'values must have size matching the lengths of the supplied grid inputs.');
            end
        end
    end
end
