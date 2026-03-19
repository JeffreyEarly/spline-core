classdef InterpolatingSpline < BSpline
    % Interpolating spline fit through data values.
    %
    % Supported construction forms:
    %   f = InterpolatingSpline(t,x)
    %   f = InterpolatingSpline(t,x,K=K)
    %   f = InterpolatingSpline(t,x,S=S)

    methods
        function self = InterpolatingSpline(t,x,options)
            % Create an interpolating spline through samples x observed at t.
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
if isnan(value)
    return;
end

mustBeNonnegative(value);
mustBeInteger(value);
end
