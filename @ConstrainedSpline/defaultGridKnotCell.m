function tKnot = defaultGridKnotCell(gridVectors, K, dataDOF, splineDOF)
% Create a knot cell from rectilinear grid vectors.
numDimensions = numel(gridVectors);
tKnot = cell(1, numDimensions);
useSplineDOF = ~isempty(splineDOF);
for iDim = 1:numDimensions
    coordinateValues = reshape(gridVectors{iDim}, [], 1);
    if useSplineDOF
        tKnot{iDim} = ConstrainedSpline.automaticKnotPoints(coordinateValues, K(iDim), splineDOF=splineDOF(iDim));
    else
        tKnot{iDim} = ConstrainedSpline.automaticKnotPoints(coordinateValues, K(iDim), dataDOF=dataDOF(iDim));
    end
end
