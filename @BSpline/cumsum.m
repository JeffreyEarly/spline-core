function intspline = cumsum(spline)
% indefinite integral of a BSpline
%
% - Topic: Operations
arguments
    spline (1,1) BSpline
end

xi = spline.xi;
K = spline.K;
tKnot = spline.tKnot;
M = length(xi);

if abs(spline.x_mean) > 0 || abs(spline.x_std - 1) > 0
    t = BSpline.pointsOfSupport(spline.tKnot,spline.K);
    X = BSpline.matrix(t,spline.tKnot,spline.K);
    xi = spline.x_std*spline.xi + X\(spline.x_mean*ones(length(t),1));
end

dt = (tKnot(1+K:M+K)-tKnot(1:M))/K;
beta = [0; cumsum(xi.*dt)];

tKnot = cat(1,spline.tKnot(1),spline.tKnot,spline.tKnot(end));
intspline = BSpline(spline.K+1,tKnot,beta);
