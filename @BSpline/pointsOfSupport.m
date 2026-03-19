function t = pointsOfSupport(tKnot,K,D)
% this function assumes that the spline are terminated at the
% boundary with repeat knot points.
%
% - Topic: Utility
arguments
    tKnot (:,1) double {mustBeNumeric,mustBeReal}
    K (1,1) double {mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
    D = []
end
interior_knots = tKnot(K+1:end-K);

if isempty(interior_knots)
    if K == 1
        t = tKnot;
    else
        dt = (tKnot(end)-tKnot(1))/(K-1);
        t = tKnot(1)+dt*(0:K-1)';
    end
    return
end

if mod(K,2)==1
    interior_support = interior_knots(1:(end-1))+diff(interior_knots)/2;

    n = K/2;

    dt_start = (interior_knots(1)-tKnot(1))/n;
    dt_end = (tKnot(end)-interior_knots(end))/n;
    n = ceil(n);
    t = cat(1,tKnot(1)+dt_start*(0:(n-1))', interior_support, tKnot(end)-dt_end*((n-1):-1:0)');
else
    interior_support = interior_knots;

    n = floor((K+1)/2);
    dt_start = (interior_knots(1)-tKnot(1))/n;
    dt_end = (tKnot(end)-interior_knots(end))/n;
    t = cat(1,tKnot(1)+dt_start*(0:(n-1))', interior_support, tKnot(end)-dt_end*((n-1):-1:0)');
end

end
