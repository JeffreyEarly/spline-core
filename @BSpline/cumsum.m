function intspline = cumsum(spline)
% Return the indefinite integral of a B-spline.
%
% - Topic: Operations
% - Declaration: intspline = cumsum(spline)
% - Parameter spline: BSpline instance to integrate
% - Returns intspline: BSpline representing the antiderivative
arguments
    spline (1,1) BSpline
end

xi = spline.xi;
K = spline.K;
tKnot = spline.tKnot;
M = length(xi);

if abs(spline.xMean) > 0 || abs(spline.xStd - 1) > 0
    t = BSpline.pointsOfSupport(spline.tKnot,spline.K);
    X = BSpline.matrix(t,spline.tKnot,spline.K);
    xi = spline.xStd*spline.xi + X\(spline.xMean*ones(length(t),1));
end

dt = (tKnot(1+K:M+K)-tKnot(1:M))/K;
beta = [0; cumsum(xi.*dt)];

tKnot = cat(1,spline.tKnot(1),spline.tKnot,spline.tKnot(end));
intspline = BSpline(spline.K+1,tKnot,beta);
