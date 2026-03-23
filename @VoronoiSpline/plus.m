function f = plus(f, g)
% Add a scalar offset to Voronoi-spline outputs.
arguments
    f
    g
end

if ~isa(f, 'VoronoiSpline')
    [f, g] = deal(g, f);
end

if ~isa(f, 'VoronoiSpline')
    error('VoronoiSpline:plus:UnsupportedOperand', ...
        'One operand must be a VoronoiSpline.');
elseif isempty(g)
    f = [];
elseif isnumeric(g) && isscalar(g)
    f = VoronoiSpline(f.K, f.support, f.xi, xMean=f.xMean + g, xStd=f.xStd);
else
    error('VoronoiSpline:plus:UnsupportedOperand', ...
        'Only scalar numeric offsets are supported.');
end
