function self = fromPoints(points, values, options)
% Create a tensor-product spline fit from scattered point observations.
%
% Use this entry point for scattered observations represented
% as one point per row.
%
% ```matlab
% fit = ConstrainedSpline.fromPoints([x(:), y(:)], values, K=[4 4]);
% valuesFit = fit.evaluatePoints(queryPoints);
% ```
%
% - Topic: Fit scattered data
% - Declaration: self = fromPoints(points,values,options)
% - Parameter points: numeric vector in 1-D or point matrix in higher dimensions
% - Parameter values: observation values
% - Parameter options.K: optional spline order scalar or vector with one entry per dimension
% - Parameter options.S: optional spline degree scalar or vector with one entry per dimension
% - Parameter options.tKnot: optional knot vector in 1-D or cell array of knot vectors
% - Parameter options.splineDOF: optional target number of splines per dimension
% - Parameter options.distribution: optional error model object for the fit
% - Parameter options.constraints: optional mixed SplineConstraint array
% - Returns self: ConstrainedSpline instance
arguments
    points {mustBeNumeric,mustBeReal,mustBeFinite}
    values {mustBeNumeric,mustBeReal,mustBeFinite}
    options.K {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBePositive} = 4
    options.S {mustBeNumeric,mustBeReal} = []
    options.tKnot = []
    options.splineDOF {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBeNonnegative} = []
    options.distribution = []
    options.constraints = []
end

self = ConstrainedSpline(points, values, K=options.K, S=options.S, tKnot=options.tKnot, splineDOF=options.splineDOF, distribution=options.distribution, constraints=options.constraints, inputMode="points");
