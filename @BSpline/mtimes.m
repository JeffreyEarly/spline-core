function f = mtimes(f,g)
% multiplication (*)
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
    error('BSpline:mtimes:UnsupportedOperand', 'One operand must be a BSpline.');
elseif isempty(g)
    f = [];
elseif isnumeric(g) && isscalar(g)
    f = f.affineOutputTransform(g, 0);
else
    error('BSpline:mtimes:UnsupportedOperand', 'Only scalar numeric multiplication is supported.');
end
