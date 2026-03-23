function [pointMatrix, numDimensions] = normalizePointInput(points, tKnot)
% Normalize scattered point input to an N-by-D point matrix.
if isempty(tKnot)
    if isvector(points)
        numDimensions = 1;
    else
        numDimensions = size(points, 2);
    end
else
    tKnot = ConstrainedSpline.normalizeConstructorKnotCell(tKnot, []);
    numDimensions = numel(tKnot);
end

[pointMatrix, ~] = TensorSpline.normalizePointMatrixInput(points, numDimensions);
