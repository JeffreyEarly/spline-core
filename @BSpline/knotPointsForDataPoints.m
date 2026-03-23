function tKnot = knotPointsForDataPoints( t, options)
% Construct a terminated knot sequence from sample locations.
%
% Use this helper to choose a knot sequence directly from sample
% locations before interpolation or least-squares fitting.
%
% To recover the old `dataDOF=d` behavior, convert it to
% `splineDOF = max(K, ceil(numel(t)/d))`:
%
% ```matlab
% oldDataDOF = 3;
% K = 4;
% splineDOF = max(K, ceil(numel(t)/oldDataDOF));
% tKnot = BSpline.knotPointsForDataPoints(t, K=K, splineDOF=splineDOF);
% ```
%
% ```matlab
% tKnot = BSpline.knotPointsForDataPoints(t, K=4);
% X = BSpline.matrix(t, tKnot, 4);
% xi = X \ x;
% spline = BSpline(4, tKnot, xi);
% ```
%
% - Topic: Build spline bases
% - Declaration: tKnot = knotPointsForDataPoints( t, options)
% - Parameter t: observation times (N)
% - Parameter options.K: (optional) spline order
% - Parameter options.splineDOF: (optional) approximate target number of splines
% - Returns tKnot: vector of knot point locations
arguments
    t (:,1) double
    options.K (1,1) double {mustBePositive,mustBeInteger,mustBeGreaterThanOrEqual(options.K,1)} = 4
    options.splineDOF (1,1) double = NaN
end

if ~isnan(options.splineDOF)
    mustBePositive(options.splineDOF);
    mustBeInteger(options.splineDOF);
end

if ~isnan(options.splineDOF)
    targetSplines = max(options.splineDOF, options.K);
    sampleStride = ceil(numel(t)/targetSplines);
else
    sampleStride = 1;
end

tData = sort(t);
tData = [tData(1); tData(1+sampleStride:sampleStride:end-sampleStride); tData(end)];
M = numel(tData);
mustBeGreaterThanOrEqual(M, options.K);

N = length(tData);
t_pseudo = interp1((0:N-1)',tData,linspace(0,N-1,M).');
K = options.K;

if mod(K,2) == 1
    % Odd spline order, so knots go in between points.
    dt = diff(t_pseudo);

    % This gives us M+1 knot points.
    tKnot = [t_pseudo(1); t_pseudo(1:end-1)+dt/2; t_pseudo(end)];

    % Now remove start and end knots
    for i=1:((K-1)/2)
        tKnot(2) = [];
        tKnot(end-1) = [];
    end

else
    tKnot = t_pseudo;

    % Now remove start and end knots
    for i=1:((K-2)/2)
        tKnot(2) = [];
        tKnot(end-1) = [];
    end

end
% Now we increase the multiplicity of the knot points at the beginning and
% the end of the interval so that the splines do not extend past the end
% points.
tKnot = [repmat(tKnot(1),K-1,1); tKnot; repmat(tKnot(end),K-1,1)];
end
