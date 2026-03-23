function B = matrix(X,tKnot,K,options)
% Evaluate the tensor-product basis matrix and optional derivatives.
%
% Use this to assemble a tensor-product design matrix for
% interpolation, regression, or basis inspection.
%
% ```matlab
% [Xq, Yq] = ndgrid(xq, yq);
% B = TensorSpline.matrix([Xq(:), Yq(:)], tKnot, [4 4]);
% values = B * spline.xi(:);
% ```
%
% - Topic: Build spline bases
% - Declaration: B = matrix(X,tKnot,K,options)
% - Parameter X: query locations as a point matrix
% - Parameter tKnot: cell array of knot vectors
% - Parameter K: spline order scalar or vector with one entry per dimension
% - Parameter options.D: derivative order per dimension
% - Returns B: basis matrix with one row per query point
arguments
    X {mustBeNumeric,mustBeReal}
    tKnot cell
    K {mustBeNumeric,mustBeReal,mustBeFinite}
    options.D = 0
end

numDimensions = numel(tKnot);
K = TensorSpline.normalizeOrders(K, numDimensions);
tKnot = TensorSpline.normalizeKnotCell(tKnot, numDimensions);
derivativeOrders = TensorSpline.normalizeDerivativeOrders(options.D, numDimensions);
basisSize = TensorSpline.basisSizeFromKnotCell(tKnot, K);

if numDimensions == 1
    pointMatrix = reshape(X, [], 1);
else
    if size(X,2) ~= numDimensions
        error('TensorSpline:InvalidPointMatrix', 'Point matrix must have one column per dimension.');
    end
    pointMatrix = X;
end

if any(derivativeOrders > K - 1)
    B = zeros(size(pointMatrix,1), prod(basisSize));
    return;
end

numPoints = size(pointMatrix,1);
dimensionMatrices = cell(1, numDimensions);
for iDim = 1:numDimensions
    Bi = BSpline.matrix(pointMatrix(:,iDim), tKnot{iDim}, K(iDim), D=derivativeOrders(iDim));
    dimensionMatrices{iDim} = reshape(Bi(:,:,derivativeOrders(iDim)+1), numPoints, []);
end

B = dimensionMatrices{1};
for iDim = 2:numDimensions
    previousBasis = B;
    currentBasis = dimensionMatrices{iDim};
    combinedBasis = zeros(numPoints, size(previousBasis,2) * size(currentBasis,2));
    for iPoint = 1:numPoints
        combinedBasis(iPoint,:) = kron(currentBasis(iPoint,:), previousBasis(iPoint,:));
    end
    B = combinedBasis;
end
