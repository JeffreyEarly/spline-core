function tc = minimumConstraintPoints(tKnot, K, T)
% Return a minimal set of one-dimensional locations for universal derivative constraints.
%
% For a terminated spline of order K, this chooses the smallest
% set of 1-D points needed to constrain all segments at
% polynomial degree T.
%
% ```matlab
% tc = ConstrainedSpline.minimumConstraintPoints(tKnot, 4, 0);
% ```
%
% - Topic: Choose constraint locations
% - Declaration: tc = minimumConstraintPoints(tKnot,K,T)
% - Parameter tKnot: one-dimensional knot sequence
% - Parameter K: spline order
% - Parameter T: constrained polynomial degree
% - Returns tc: one-dimensional constraint locations
arguments
    tKnot (:,1) double {mustBeNumeric,mustBeReal,mustBeFinite}
    K (1,1) double {mustBePositive,mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
    T (1,1) double {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger}
end

t = unique(tKnot);
D = K - 1 - T;
if mod(D, 2) == 0
    ts = t(1) + (t(2)-t(1))/(D/2 + 2) * (1:(D/2 + 1)).';
    te = t(end-1) + (t(end)-t(end-1))/(D/2 + 2) * (1:(D/2 + 1)).';
    ti = t(2:end-2) + diff(t(2:end-1))/2;
    tc = cat(1, ts, ti, te);
else
    ts = t(1) + (t(2)-t(1))/((D-1)/2 + 1) * (0:((D-1)/2)).';
    te = t(end) - (t(end)-t(end-1))/((D-1)/2 + 1) * (0:((D-1)/2)).';
    ti = t(2:end-1);
    tc = cat(1, ts, ti, te);
end
