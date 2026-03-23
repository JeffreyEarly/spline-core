function intspline = cumsum(spline)
% Return the indefinite integral of a B-spline.
%
% Use this to construct an antiderivative spline that can be evaluated at
% arbitrary points after integration.
%
% ```matlab
% F = cumsum(spline);
% values = F(tQuery);
% ```
%
% - Topic: Transform the spline
% - Declaration: intspline = cumsum(spline)
% - Parameter spline: BSpline instance to integrate
% - Returns intspline: BSpline representing the antiderivative
arguments
    spline (1,1) BSpline
end

xi = spline.xi;
K = spline.K;
knotPoints = spline.knotPoints;
M = length(xi);

if abs(spline.xMean) > 0 || abs(spline.xStd - 1) > 0
    t = BSpline.pointsOfSupport(spline.knotPoints, spline.S);
    X = BSpline.matrix(t, spline.knotPoints, spline.S);
    xi = spline.xStd*spline.xi + X\(spline.xMean*ones(length(t),1));
end

dt = (knotPoints(1+K:M+K)-knotPoints(1:M))/K;
beta = [0; cumsum(xi.*dt)];

knotPoints = cat(1, spline.knotPoints(1), spline.knotPoints, spline.knotPoints(end));
intspline = BSpline(S=spline.S+1, knotPoints=knotPoints, xi=beta);
