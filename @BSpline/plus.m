function f = plus(f,g)
% addition (+)
%
% - Topic: Operations
arguments
    f
    g
end

if ~isa(f,'BSpline')
    [f, g] = deal(g, f);
end

if ~isa(f,'BSpline')
    error('BSpline:plus:UnsupportedOperand', 'One operand must be a BSpline.');
elseif isempty(g)
    f = [];
elseif isnumeric(g) && isscalar(g)
    f = f.affineOutputTransform(1, g);
else
    error('BSpline:plus:UnsupportedOperand', 'Only scalar numeric offsets are supported.');
end
