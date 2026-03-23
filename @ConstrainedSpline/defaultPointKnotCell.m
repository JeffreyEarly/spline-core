function tKnot = defaultPointKnotCell(pointMatrix, K, splineDOF)
% Create a safe knot cell for scattered points.
numDimensions = size(pointMatrix, 2);
coordinateValues = cell(1, numDimensions);
numUnique = zeros(1, numDimensions);
for iDim = 1:numDimensions
    coordinateValues{iDim} = unique(pointMatrix(:,iDim), 'sorted');
    numUnique(iDim) = numel(coordinateValues{iDim});
end

tKnot = cell(1, numDimensions);
if ~isempty(splineDOF)
    for iDim = 1:numDimensions
        tKnot{iDim} = ConstrainedSpline.automaticKnotPoints(coordinateValues{iDim}, K(iDim), splineDOF=splineDOF(iDim));
    end

    if ~ConstrainedSpline.pointBasisIsSafe(pointMatrix, tKnot, K)
        error('ConstrainedSpline:UnsafeSplineDOF',  'The supplied splineDOF produced an unsafe tensor basis. Pass tKnot or a smaller splineDOF.');
    end
    return;
end

if size(pointMatrix, 1) < prod(K)
    error('ConstrainedSpline:InsufficientPointsForMinimumBasis',  'There are not enough points to support the minimum tensor basis. Pass more points or a lower-order K.');
end

targetSplineDOF = min(numUnique, max(K, repmat(floor(size(pointMatrix,1)^(1/numDimensions)), 1, numDimensions)));
while true
    for iDim = 1:numDimensions
        tKnot{iDim} = ConstrainedSpline.automaticKnotPoints(coordinateValues{iDim}, K(iDim), splineDOF=targetSplineDOF(iDim));
    end

    [isSafe, basisSize] = ConstrainedSpline.pointBasisIsSafe(pointMatrix, tKnot, K);
    if isSafe
        return;
    end

    bestDim = 0;
    for iDim = 1:numDimensions
        if targetSplineDOF(iDim) <= K(iDim)
            continue;
        end

        if bestDim == 0 || basisSize(iDim) > basisSize(bestDim) || (basisSize(iDim) == basisSize(bestDim) && numUnique(iDim) > numUnique(bestDim)) || (basisSize(iDim) == basisSize(bestDim) && numUnique(iDim) == numUnique(bestDim) && iDim < bestDim)
            bestDim = iDim;
        end
    end

    if bestDim == 0
        break;
    end

    targetSplineDOF(bestDim) = targetSplineDOF(bestDim) - 1;
end

error('ConstrainedSpline:UnsafeAutomaticKnotSelection',  'Automatic scattered-data knot selection could not find a safe tensor basis. Pass tKnot or a smaller splineDOF.');
