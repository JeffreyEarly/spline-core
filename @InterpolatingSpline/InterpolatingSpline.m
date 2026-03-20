classdef InterpolatingSpline < BSpline
    % Interpolating spline fit through data values.
    %
    % Supported construction forms:
    %   f = InterpolatingSpline(t,x)
    %   f = InterpolatingSpline(t,x,K=K)
    %   f = InterpolatingSpline(t,x,S=S)
    %
    % The constructor chooses a terminated knot sequence from the supplied
    % sample locations and solves for coefficients that interpolate the
    % provided values exactly.
    %
    % - Topic: Initialization
    % - Topic: Utility
    % - Declaration: classdef InterpolatingSpline < BSpline

    methods
        function self = InterpolatingSpline(t,x,options)
            % Create an interpolating spline through samples x observed at t.
            %
            % - Topic: Initialization
            % - Declaration: self = InterpolatingSpline(t,x,options)
            % - Parameter t: sample locations
            % - Parameter x: sample values
            % - Parameter options.K: spline order, used when options.S is not supplied
            % - Parameter options.S: spline degree, alternative to specifying options.K
            % - Returns self: InterpolatingSpline instance
            arguments
                t {mustBeNumeric,mustBeReal,mustBeFinite}
                x {mustBeNumeric,mustBeReal,mustBeFinite}
                options.K (1,1) double {mustBePositive,mustBeInteger,mustBeGreaterThanOrEqual(options.K,1)} = 4
                options.S (1,1) double {mustBeNonnegativeOrNaNInteger} = NaN
            end

            t = reshape(t,[],1);
            x = reshape(x,[],1);

            if numel(x) ~= numel(t)
                error('InterpolatingSpline:SizeMismatch', 'x and t must have the same length.');
            end

            K = InterpolatingSpline.splineOrderFromOptions(options);
            tKnot = BSpline.knotPointsForDataPoints(t,K=K);

            xMean = mean(x);
            x = x - xMean;

            xStd = std(x);
            if xStd > 0
                x = x/xStd;
            else
                xStd = 1;
            end

            X = BSpline.matrix(t,tKnot,K);
            xi = X\x;

            self@BSpline(K,tKnot,xi,x_mean=xMean,x_std=xStd);
        end
    end

    methods (Static)
        function K = splineOrderFromOptions(options)
            % Resolve spline order from mutually exclusive K and S options.
            %
            % - Topic: Utility
            % - Declaration: K = splineOrderFromOptions(options)
            % - Parameter options: struct with fields K and S
            % - Returns K: spline order
            arguments
                options struct
            end

            if isnan(options.S)
                K = options.K;
            else
                if options.K ~= 4
                    error('InterpolatingSpline:ConflictingSplineOrder', 'Specify either K or S, but not both.');
                end
                K = options.S + 1;
            end
        end
    end
end

function mustBeNonnegativeOrNaNInteger(value)
% Validate that a value is either NaN or a nonnegative integer.
if isnan(value)
    return;
end

mustBeNonnegative(value);
mustBeInteger(value);
end
