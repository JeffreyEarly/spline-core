function dspline = diff(self, derivativeOrders)
% Differentiate a Voronoi spline.
arguments
    self (1,1) VoronoiSpline
    derivativeOrders {mustBeNumeric,mustBeReal,mustBeFinite,mustBeNonnegative,mustBeInteger} = 1
end

if self.numDimensions ~= 1
    error('VoronoiSpline:diff:UnsupportedDimension', ...
        'diff is currently implemented only for 1-D VoronoiSpline objects.');
end

backingSpline = BSpline(self.K, self.support.tKnot, self.xi);
dsplineBSpline = diff(backingSpline, derivativeOrders);
support = struct();
if dsplineBSpline.K == 1
    support.sites = dsplineBSpline.tKnot(1:end-1) + diff(dsplineBSpline.tKnot) / 2;
else
    support.sites = BSpline.pointsOfSupport(dsplineBSpline.tKnot, dsplineBSpline.K);
end
support.tKnot = dsplineBSpline.tKnot;
dspline = VoronoiSpline(dsplineBSpline.K, support, dsplineBSpline.xi, xMean=0, xStd=self.xStd);
