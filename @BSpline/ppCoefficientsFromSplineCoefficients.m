function [C,tpp,Xtpp] = ppCoefficientsFromSplineCoefficients( xi, tKnot, K, options )
% Returns the piecewise polynomial coefficients in matrix C from spline coefficients in vector xi.
%
% - Topic: Spline evaluation
% - Declaration: ppCoefficientsFromSplineCoefficients( xi, tKnot, K, Xtpp )
% - Parameter xi: spline coefficients
% - Parameter tKnot: spline knot points
% - Parameter K: spline order (degree S=K-1)
% - Parameter Xtpp: (optional) splines at the points tpp
% - Returns C: polynomial coefficients to be used in polyval, size(C) = [length(tpp)-1, K]
% - Returns tpp: piece-wise polynomial intervals, size(tpp) = numel(tKnot) - 2*K + 1
% - Returns Xtpp: splines at the points tpp
arguments
    xi (:,1) double
    tKnot (:,1) double {mustBeNumeric,mustBeReal}
    K (1,1) double {mustBePositive,mustBeInteger,mustBeGreaterThanOrEqual(K,1)}
    options.Xtpp (:,:,:) double
end

Nk = length(tKnot);
tpp = tKnot(K:(Nk-K+1));
if ~isfield(options,'Xtpp') || isempty(options.Xtpp)
    Xtpp = BSpline.matrix( tpp, tKnot, K, D=K-1 );
else
    Xtpp = options.Xtpp;
end

% Build an array of coefficients for polyval, highest order first.
C = zeros(length(tpp)-1,K);
for i=1:K
    C(:,K-i+1) = Xtpp(1:end-1,:,i)*xi;
end

end
