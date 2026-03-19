function splineb = power(spline,b,constraints)
% power (.^)
%
% - Topic: Operations
if b == 1
    splineb = spline;
else
    ts = BSpline.PointsOfSupport(spline.tKnot,spline.K,0);
    g = spline.valueAtPoints(ts);
    g(abs(2*eps)>g) = 0;
%         splineb = InterpolatingSpline(ts,(g.^b),ceil(b*spline.K));
        K = ceil(b*spline.K);
%     K = spline.K;
    tKnot = InterpolatingSpline.KnotPointsForPoints(ts,K);
    if exist('constraints','var') && ~isempty(constraints)
        splineb = ConstrainedSpline(ts,(g.^b),K,tKnot,[],constraints);
    else
        X = BSpline.Spline(ts,tKnot,K);
        m = X\(g.^b);
        splineb = BSpline(K,tKnot,m);
    end
    
end

