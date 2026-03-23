function B = matrix(X, knotPoints, S, options)
% Evaluate the tensor-product basis matrix and optional derivatives.
%
% Use this to assemble a tensor-product design matrix for
% interpolation, regression, or basis inspection.
%
% ```matlab
% [Xq, Yq] = ndgrid(xq, yq);
% B = TensorSpline.matrix([Xq(:), Yq(:)], knotPoints, [3 3]);
% values = B * spline.xi(:);
% ```
%
% - Topic: Build spline bases
% - Declaration: B = matrix(X, knotPoints, S, options)
% - Parameter X: query locations as a point matrix
% - Parameter knotPoints: knot vector in 1-D or cell array of knot vectors
% - Parameter S: spline degree scalar or vector with one entry per dimension
% - Parameter options.D: derivative order per dimension
% - Returns B: basis matrix with one row per query point
arguments
    X {mustBeNumeric,mustBeReal}
    knotPoints
    S {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBeNonnegative}
    options.D = 0
end

if isnumeric(knotPoints)
    validateattributes(knotPoints, {'numeric'}, {'vector','real','finite','nonempty'});
    numDimensions = 1;
    tKnot = {reshape(knotPoints, [], 1)};
else
    numDimensions = numel(knotPoints);
    tKnot = TensorSpline.normalizeKnotCell(knotPoints, numDimensions);
end
K = TensorSpline.normalizeOrders(S + 1, numDimensions);
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
    Bi = BSpline.matrix(pointMatrix(:,iDim), tKnot{iDim}, K(iDim) - 1, D=derivativeOrders(iDim));
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
