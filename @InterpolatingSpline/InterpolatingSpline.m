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
            tKnot = InterpolatingSpline.KnotPointsForPoints(t,K);

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
        function tKnot = KnotPointsForPoints(t, K, DF)
            % Return canonical knot points for interpolation support points t.
            arguments
                t {mustBeNumeric,mustBeReal,mustBeFinite}
                K (1,1) double {mustBePositive,mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
                DF (1,1) double {mustBePositive,mustBeInteger} = 1
            end

            t = sort(reshape(t,[],1));
            t = [t(1); t(1+DF:DF:end-DF); t(end)];
            tKnot = BSpline.knotPointsForDataPoints(t, K=K, M=numel(t));
        end

        function tKnot = KnotPointsForSplines(t, K, nSplines)
            % Create knot points that target approximately nSplines basis functions.
            arguments
                t {mustBeNumeric,mustBeReal,mustBeFinite}
                K (1,1) double {mustBePositive,mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
                nSplines (1,1) double {mustBePositive,mustBeInteger}
            end

            nSplines = max(nSplines,K);
            tKnot = InterpolatingSpline.KnotPointsForPoints(t,K,ceil(numel(t)/nSplines));
        end

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
