function poweredSpline = power(spline,exponent)
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
% - Declaration: poweredSpline = power(spline,exponent)
% - Parameter spline: BSpline instance
% - Parameter exponent: scalar exponent
% - Returns poweredSpline: BSpline approximating spline.^exponent
arguments
    spline (1,1) BSpline
    exponent (1,1) double {mustBeReal,mustBeFinite}
end
if exponent == 1
    poweredSpline = spline;
    return;
end

supportPoints = BSpline.pointsOfSupport(spline.knotPoints, spline.S);
values = spline.valueAtPoints(supportPoints);
values(abs(values) < 2*eps) = 0;

poweredK = ceil(exponent*spline.K);
knotPoints = BSpline.knotPointsForDataPoints(supportPoints, S=poweredK-1);
poweredValues = values.^exponent;
[constraintArguments, poweredValues] = ConstrainedSpline.constraintArguments(  [], poweredValues, enforcePositiveIfPossible=true, numDimensions=1);
if ~isempty(constraintArguments)
    fittedSpline = ConstrainedSpline(supportPoints, poweredValues, S=poweredK-1, knotPoints=knotPoints, constraintArguments{:});
    poweredSpline = BSpline(S=poweredK-1, knotPoints=fittedSpline.knotPoints, xi=fittedSpline.xi(:));
else
    X = BSpline.matrix(supportPoints, knotPoints, poweredK-1);
    xi = X\poweredValues;
    poweredSpline = BSpline(S=poweredK-1, knotPoints=knotPoints, xi=xi);
end
