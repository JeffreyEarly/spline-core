function poweredSpline = power(spline,exponent,constraints)
% power (.^)
%
% - Topic: Operations
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

if ~isempty(constraints)
    poweredSpline = ConstrainedSpline(supportPoints,poweredValues,poweredOrder,tKnot,[],constraints);
else
    X = BSpline.matrix(supportPoints,tKnot,poweredOrder);
    xi = X\poweredValues;
    poweredSpline = BSpline(poweredOrder,tKnot,xi);
end
