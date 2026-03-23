function [pointMatrix, supportVectors] = pointsOfSupport(tKnot, K, D)
% Return representative support points for a tensor-product spline basis.
%
% Use these points when you need one representative location per tensor
% basis function, for example when constructing transformed splines from
% sampled values.
%
% ```matlab
% [supportPoints, supportVectors] = TensorSpline.pointsOfSupport(tKnot, [4 4]);
% values = spline(supportVectors{:});
% ```
%
% - Topic: Build spline bases
% - Declaration: [pointMatrix,supportVectors] = pointsOfSupport(tKnot,K,D)
% - Parameter tKnot: cell array of knot vectors
% - Parameter K: spline order scalar or vector with one entry per dimension
% - Parameter D: reserved derivative-order argument for API compatibility
% - Returns pointMatrix: matrix with one row per tensor support point
% - Returns supportVectors: cell array with one support vector per dimension
arguments
    tKnot cell
    K {mustBeNumeric,mustBeReal,mustBeFinite}
    D (1,1) double {mustBeInteger,mustBeNonnegative} = 0
end

% D is reserved for API compatibility.
numDimensions = numel(tKnot);
K = TensorSpline.normalizeOrders(K, numDimensions);
tKnot = TensorSpline.normalizeKnotCell(tKnot, numDimensions);

supportVectors = cell(1, numDimensions);
for iDim = 1:numDimensions
    supportVectors{iDim} = BSpline.pointsOfSupport(tKnot{iDim}, K(iDim), D);
end

pointMatrix = TensorSpline.pointsFromGridVectors(supportVectors);
