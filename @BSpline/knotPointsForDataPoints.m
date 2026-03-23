function knotPoints = knotPointsForDataPoints(t, options)
% Construct a terminated knot sequence from sample locations.
%
% Use this helper to choose a knot sequence directly from sample
% locations before interpolation or least-squares fitting.
%
% To recover the old `dataDOF=d` behavior, convert it to
% `splineDOF = max(S+1, ceil(numel(t)/d))`:
%
% ```matlab
% oldDataDOF = 3;
% S = 3;
% splineDOF = max(S+1, ceil(numel(t)/oldDataDOF));
% knotPoints = BSpline.knotPointsForDataPoints(t, S=S, splineDOF=splineDOF);
% ```
%
% ```matlab
% knotPoints = BSpline.knotPointsForDataPoints(t, S=3);
% X = BSpline.matrix(t, knotPoints, 3);
% xi = X \ x;
% spline = BSpline(S=3, knotPoints=knotPoints, xi=xi);
% ```
%
% - Topic: Build spline bases
% - Declaration: knotPoints = knotPointsForDataPoints(t, options)
% - Parameter t: observation times (N)
% - Parameter options.S: (optional) spline degree
% - Parameter options.splineDOF: (optional) approximate target number of splines
% - Returns knotPoints: vector of knot point locations
arguments
    t (:,1) double
    options.S (1,1) double {mustBeNonnegative,mustBeInteger} = 3
    options.splineDOF (1,1) double = NaN
end
K = options.S + 1;

if ~isnan(options.splineDOF)
    mustBePositive(options.splineDOF);
    mustBeInteger(options.splineDOF);
end

if ~isnan(options.splineDOF)
    targetSplines = max(options.splineDOF, K);
    sampleStride = ceil(numel(t)/targetSplines);
else
    sampleStride = 1;
end

tData = sort(t);
tData = [tData(1); tData(1+sampleStride:sampleStride:end-sampleStride); tData(end)];
M = numel(tData);
mustBeGreaterThanOrEqual(M, K);

N = length(tData);
t_pseudo = interp1((0:N-1)',tData,linspace(0,N-1,M).');

if mod(K,2) == 1
    % Odd spline order, so knots go in between points.
    dt = diff(t_pseudo);

    % This gives us M+1 knot points.
    knotPoints = [t_pseudo(1); t_pseudo(1:end-1)+dt/2; t_pseudo(end)];

    % Now remove start and end knots
    for i=1:((K-1)/2)
        knotPoints(2) = [];
        knotPoints(end-1) = [];
    end

else
    knotPoints = t_pseudo;

    % Now remove start and end knots
    for i=1:((K-2)/2)
        knotPoints(2) = [];
        knotPoints(end-1) = [];
    end

end
% Now we increase the multiplicity of the knot points at the beginning and
% the end of the interval so that the splines do not extend past the end
% points.
knotPoints = [repmat(knotPoints(1),K-1,1); knotPoints; repmat(knotPoints(end),K-1,1)];
end
