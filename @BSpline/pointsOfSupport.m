function t = pointsOfSupport(knotPoints, S)
% Return representative support points for a terminated spline basis.
%
% This function assumes that the splines are terminated at the
% boundary with repeated end knots.
%
% Use these points when you need one representative location per basis
% function, for example when constructing transformed splines from sampled
% values.
%
% ```matlab
% tSupport = BSpline.pointsOfSupport(knotPoints, 3);
% xSupport = spline(tSupport);
% ```
%
% - Topic: Build spline bases
% - Declaration: t = pointsOfSupport(knotPoints, S)
% - Parameter knotPoints: knot sequence
% - Parameter S: spline degree
% - Returns t: support point locations
arguments
    knotPoints (:,1) double {mustBeNumeric,mustBeReal}
    S (1,1) double {mustBeInteger,mustBeNonnegative}
end
K = S + 1;
interior_knots = knotPoints(K+1:end-K);

if isempty(interior_knots)
    if K == 1
        t = knotPoints;
    else
        dt = (knotPoints(end)-knotPoints(1))/(K-1);
        t = knotPoints(1)+dt*(0:K-1)';
    end
    return
end

if mod(K,2)==1
    interior_support = interior_knots(1:(end-1))+diff(interior_knots)/2;

    n = K/2;

    dt_start = (interior_knots(1)-knotPoints(1))/n;
    dt_end = (knotPoints(end)-interior_knots(end))/n;
    n = ceil(n);
    t = cat(1,knotPoints(1)+dt_start*(0:(n-1))', interior_support, knotPoints(end)-dt_end*((n-1):-1:0)');
else
    interior_support = interior_knots;

    n = floor((K+1)/2);
    dt_start = (interior_knots(1)-knotPoints(1))/n;
    dt_end = (knotPoints(end)-interior_knots(end))/n;
    t = cat(1,knotPoints(1)+dt_start*(0:(n-1))', interior_support, knotPoints(end)-dt_end*((n-1):-1:0)');
end

end
