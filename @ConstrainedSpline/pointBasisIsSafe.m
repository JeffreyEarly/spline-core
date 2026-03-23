function [isSafe, basisSize] = pointBasisIsSafe(pointMatrix, tKnot, K)
% Check whether a scattered-point tensor basis is safe to solve.
basisSize = reshape(cellfun(@numel, tKnot), 1, []) - reshape(K, 1, []);
X = sparse(TensorSpline.matrix(pointMatrix, tKnot, K));

if size(X,2) > size(X,1)
    isSafe = false;
    return;
end

if any(full(sum(X ~= 0, 1)) == 0)
    isSafe = false;
    return;
end

[~, R] = qr(X, 0);
diagR = abs(diag(R));
if isempty(diagR)
    isSafe = true;
    return;
end

tolerance = max(size(X)) * eps(class(diagR)) * max(diagR);
isSafe = nnz(diagR > tolerance) == size(X,2);
