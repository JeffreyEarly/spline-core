function [xi, tKnot, K] = differentiateAlongDimension(xi, tKnot, K, derivativeOrder, dim)
% Differentiate tensor coefficients along one dimension.
%
% - Topic: Utility
% - Developer: true
% - Declaration: [xi,tKnot,K] = differentiateAlongDimension(xi,tKnot,K,derivativeOrder,dim)
perm = [dim, 1:(dim-1), (dim+1):ndims(xi)];
xiPermuted = permute(xi, perm);
xiMatrix = reshape(xiPermuted, size(xiPermuted, 1), []);

originalK = K;
originalTKnot = tKnot;
transformedSlice = diff(BSpline(originalK, originalTKnot, xiMatrix(:,1)), derivativeOrder);
tKnot = transformedSlice.tKnot;
K = transformedSlice.K;

transformedMatrix = zeros(numel(transformedSlice.xi), size(xiMatrix, 2), 'like', xiMatrix);
transformedMatrix(:,1) = transformedSlice.xi;
for iSlice = 2:size(xiMatrix, 2)
    transformedSlice = diff(BSpline(originalK, originalTKnot, xiMatrix(:,iSlice)), derivativeOrder);
    transformedMatrix(:,iSlice) = transformedSlice.xi;
end

outputSize = size(xiPermuted);
outputSize(1) = size(transformedMatrix, 1);
xi = ipermute(reshape(transformedMatrix, outputSize), perm);
