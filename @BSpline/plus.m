function f = plus(f,g)
% addition (+)
%
% - Topic: Operations
arguments
    f
    g
end
if ( ~isa(f, 'BSpline') )
    % Ensure BSpline is the first input:
    f = plus(g, f);
elseif ( isempty(g) )          % BSpline * []
    f = [];
elseif ( isnumeric(g) && isscalar(g) )
    %     X = f.Xtpp(:,:,1);
    %     xi0 = X\ones(size(X,1),1);
    %     f = BSpline(f.K,f.tKnot,f.xi + g*xi0);
    h = BSpline(f.K,f.tKnot,f.xi);
    h.x_std = f.x_std;
    h.x_mean = f.x_mean+g;
    f = h;
else
    error('BSpline:plus:UnsupportedOperand', 'Only scalar numeric offsets are supported.');
end
