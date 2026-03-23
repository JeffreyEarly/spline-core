function [normalMatrix, rhs] = weightedNormalEquations(X, x, W)
% Assemble weighted normal equations.
XT = X';
if isa(W, 'decomposition')
    weightedX = W \ X;
    normalMatrix = XT*weightedX;
    rhs = XT*(W \ x);
elseif size(W,1) == length(x) && size(W,2) == length(x)
    normalMatrix = XT*W*X;
    rhs = XT*W*x;
elseif isscalar(W)
    normalMatrix = (XT*X)*W;
    rhs = XT*W*x;
elseif isvector(W) && numel(W) == length(x)
    normalMatrix = XT*(W.*X);
    rhs = XT*(W.*x);
else
    error('W must have the same length as x and X.');
end
