function f = evaluateFromPPCoefficients(t,C,tpp, D)
% Evaluate a cached piecewise-polynomial spline representation.
%
% On interval `i`, let `u = t - tpp(i)`. This function evaluates
%
% $$
% f_i^{(D)}(u) = \sum_{m=D}^{S} \frac{c_{i,m}}{(m-D)!} u^{m-D},
% $$
%
% where the interval coefficients \(c_{i,m}\) are stored in `C`.
%
% ```matlab
% xq = BSpline.evaluateFromPPCoefficients(tQuery, C, tpp);
% dxq = BSpline.evaluateFromPPCoefficients(tQuery, C, tpp, 1);
% ```
%
% - Topic: Represent piecewise polynomials
% - Developer: true
% - Declaration: f = evaluateFromPPCoefficients(t,C,tpp, D)
% - Parameter t: points at which to evaluate the splines
% - Parameter C: polynomial coefficients to be used in polyval, size(C) = [length(tpp)-1, K]
% - Parameter tpp: piece-wise polynomial intervals
% - Parameter D: number of derivatives
% - Returns f: array the same size as t
arguments
    t {mustBeNumeric,mustBeReal}
    C (:,:) double
    tpp (:,1) double {mustBeNumeric,mustBeReal}
    D (1,1) double {mustBeInteger,mustBeNonnegative} = 0
end

K = size(C,2);
f = zeros(size(t), 'like', t);

if D > K-1
    % By construction the splines are zero for K or more derivs
    return;
end

scale = factorial((K-1-D):-1:0);
indices = 1:(K-D);
scaledC = C(:,indices)./scale;

% Evaluate on a sorted copy so interval bins are contiguous, then restore
% the original ordering and shape.
[tSorted, sortIndices] = sort(t(:), 'ascend');
t_pp_bin = discretize(tSorted, [-Inf; tpp(2:end-1); Inf]);
fSorted = zeros(size(tSorted), 'like', tSorted);

startIndex = 1;
while startIndex <= numel(tSorted)
    iBin = t_pp_bin(startIndex);
    endIndex = startIndex + find(t_pp_bin(startIndex:end) ~= iBin, 1, 'first') - 2;
    if isempty(endIndex)
        endIndex = numel(tSorted);
    end
    coeffs = scaledC(iBin,:);
    fSorted(startIndex:endIndex) = polyval(coeffs, tSorted(startIndex:endIndex) - tpp(iBin));
    startIndex = endIndex + 1;
end

fFlat = zeros(numel(t), 1, 'like', t);
fFlat(sortIndices) = fSorted;
f = reshape(fFlat, size(t));
end
