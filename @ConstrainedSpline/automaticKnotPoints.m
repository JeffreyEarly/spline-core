function tKnot = automaticKnotPoints(coordinateValues, K, options)
% Build one-dimensional knots while allowing repeated coordinates.
arguments
    coordinateValues (:,1) double {mustBeNumeric,mustBeReal,mustBeFinite}
    K (1,1) double {mustBePositive,mustBeInteger}
    options.dataDOF (1,1) double {mustBePositive,mustBeInteger} = 1
    options.splineDOF (1,1) double = NaN
end

uniqueValues = unique(coordinateValues, 'sorted');
if numel(uniqueValues) < K
    tKnot = [repmat(uniqueValues(1), K, 1); repmat(uniqueValues(end), K, 1)];
    return;
end

if isnan(options.splineDOF)
    tKnot = BSpline.knotPointsForDataPoints(coordinateValues, K=K, dataDOF=options.dataDOF);
else
    tKnot = BSpline.knotPointsForDataPoints(coordinateValues, K=K, splineDOF=options.splineDOF);
end
