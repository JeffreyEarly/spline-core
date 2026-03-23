function poweredSpline = power(spline,exponent,constraints)
% Raise spline values to a real scalar power by refitting support values.
%
% This is useful for simple nonlinear transforms of a spline when an exact
% spline-space representation is not available.
%
% ```matlab
% squaredSpline = spline.^2;
% reciprocalRootSpline = spline.^(-0.5);
% ```
%
% - Topic: Transform the spline
% - Declaration: poweredSpline = power(spline,exponent,constraints)
% - Parameter spline: BSpline instance
% - Parameter exponent: scalar exponent
% - Parameter constraints: optional SplineConstraint array for the refit
% - Returns poweredSpline: BSpline approximating spline.^exponent
arguments
    spline (1,1) BSpline
    exponent (1,1) double {mustBeReal,mustBeFinite}
    constraints = []
end
if exponent == 1
    poweredSpline = spline;
    return;
end

supportPoints = BSpline.pointsOfSupport(spline.tKnot,spline.K,0);
values = spline.valueAtPoints(supportPoints);
values(abs(values) < 2*eps) = 0;

poweredOrder = ceil(exponent*spline.K);
tKnot = BSpline.knotPointsForDataPoints(supportPoints,K=poweredOrder);
poweredValues = values.^exponent;
[constraintArguments, poweredValues] = ConstrainedSpline.constraintArguments( ...
    constraints, poweredValues, EnforcePositiveIfPossible=true, NumDimensions=1);
if ~isempty(constraintArguments)
    fittedSpline = ConstrainedSpline(supportPoints, poweredValues, ...
        K=poweredOrder, ...
        tKnot=tKnot, ...
        constraintArguments{:});
    poweredSpline = BSpline(poweredOrder, fittedSpline.tKnot, fittedSpline.xi(:));
else
    X = BSpline.matrix(supportPoints,tKnot,poweredOrder);
    xi = X\poweredValues;
    poweredSpline = BSpline(poweredOrder,tKnot,xi);
end
