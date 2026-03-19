function splineb = power(spline,b,constraints)
% power (.^)
%
% - Topic: Operations
arguments
    spline (1,1) BSpline
    b (1,1) double
    constraints = []
end
if b == 1
    splineb = spline;
else
    ts = BSpline.pointsOfSupport(spline.tKnot,spline.K,0);
    g = spline.valueAtPoints(ts);
    g(abs(2*eps)>g) = 0;
    K = ceil(b*spline.K);
    tKnot = BSpline.knotPointsForDataPoints(ts,K=K);
    if ~isempty(constraints)
        splineb = ConstrainedSpline(ts,(g.^b),K,tKnot,[],constraints);
    else
        X = BSpline.matrix(ts,tKnot,K);
        xi = X\(g.^b);
        splineb = BSpline(K,tKnot,xi);
    end
    
end
