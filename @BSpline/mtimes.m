function f = mtimes(f,g)
% multiplication (.*)
%
% - Topic: Operations
arguments
    f
    g
end

if ( ~isa(f, 'BSpline') )
    % Ensure BSpline is the first input:
    f = mtimes(g, f);
elseif ( isempty(g) )          % BSpline * []
    f = [];
elseif ( isnumeric(g) && isscalar(g) )
    h = BSpline(f.K,f.tKnot,f.xi);
    h.x_std = g*f.x_std;
    h.x_mean = g*f.x_mean;
    f = h;
else
    error('BSpline:mtimes:UnsupportedOperand', 'Only scalar numeric multiplication is supported.');
end
