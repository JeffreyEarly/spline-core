function f = mtimes(f, g)
% Multiply Voronoi-spline outputs by a scalar.
arguments
    f
    g
end

if ~isa(f, 'VoronoiSpline')
    [f, g] = deal(g, f);
end

if ~isa(f, 'VoronoiSpline')
    error('VoronoiSpline:mtimes:UnsupportedOperand', ...
        'One operand must be a VoronoiSpline.');
elseif isempty(g)
    f = [];
elseif isnumeric(g) && isscalar(g)
    f = VoronoiSpline(f.K, f.support, f.xi, xMean=g * f.xMean, xStd=g * f.xStd);
else
    error('VoronoiSpline:mtimes:UnsupportedOperand', ...
        'Only scalar numeric multiplication is supported.');
end
