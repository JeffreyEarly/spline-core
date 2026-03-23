function [pointMatrix, outputSize] = normalizePointMatrixInput(X, numDimensions)
% Normalize query locations from point-matrix form.
validateattributes(X, {'numeric'}, {'real'});
if numDimensions == 1
    outputSize = size(X);
    pointMatrix = reshape(X, [], 1);
else
    if size(X,2) ~= numDimensions
        error('TensorSpline:InvalidPointMatrix', 'Point matrix must have one column per dimension.');
    end
    outputSize = [size(X,1), 1];
    pointMatrix = X;
end
