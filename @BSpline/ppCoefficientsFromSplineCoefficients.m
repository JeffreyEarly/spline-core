function [C,tpp,Xtpp] = ppCoefficientsFromSplineCoefficients(xi, knotPoints, S, options)
% Convert spline coefficients into piecewise-polynomial interval coefficients.
%
% This helper rewrites the spline as local Taylor data over each interval.
% If `u = t - tpp(i)` on interval `i`, the cached representation satisfies
%
% $$
% f_i(u) = \sum_{m=0}^{S} \frac{c_{i,m}}{m!} u^m,
% $$
%
% where the rows of `C` store the coefficients $$c_{i,m}$$ in the order
% expected by `polyval` after the factorial scaling used in
% `evaluateFromPPCoefficients`.
%
% ```matlab
% [C, tpp] = BSpline.ppCoefficientsFromSplineCoefficients(xi, knotPoints, 3);
% xq = BSpline.evaluateFromPPCoefficients(tQuery, C, tpp);
% ```
%
% - Topic: Represent piecewise polynomials
% - Developer: true
% - Declaration: ppCoefficientsFromSplineCoefficients(xi, knotPoints, S, Xtpp)
% - Parameter xi: spline coefficients
% - Parameter knotPoints: spline knot points
% - Parameter S: spline degree
% - Parameter options.Xtpp: (optional) splines at the points tpp
% - Returns C: polynomial coefficients to be used in polyval, size(C) = [length(tpp)-1, K]
% - Returns tpp: piece-wise polynomial intervals, size(tpp) = numel(knotPoints) - 2*S - 1
% - Returns Xtpp: splines at the points tpp
arguments
    xi (:,1) double
    knotPoints (:,1) double {mustBeNumeric,mustBeReal}
    S (1,1) double {mustBeNonnegative,mustBeInteger}
    options.Xtpp (:,:,:) double
end
K = S + 1;

Nk = length(knotPoints);
tpp = knotPoints(K:(Nk-K+1));
if ~isfield(options,'Xtpp') || isempty(options.Xtpp)
    Xtpp = BSpline.matrix(tpp, knotPoints, S, D=S);
else
    Xtpp = options.Xtpp;
end

% Build an array of coefficients for polyval, highest order first.
C = zeros(length(tpp)-1,K);
for i=1:K
    C(:,K-i+1) = Xtpp(1:end-1,:,i)*xi;
end

end
