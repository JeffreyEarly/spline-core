function W = weightMatrixFromSigma2(sigma2, rho_X)
% Build the observation-weight matrix from per-observation variances.
if ~isempty(rho_X)
    Sigma2 = (sqrt(sigma2) * sqrt(sigma2).') .* rho_X;
    W = decomposition(Sigma2);
else
    W = 1./sigma2;
end
