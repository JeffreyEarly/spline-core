function [pointMatrix, outputSize] = normalizeQueryInputs(queryInputs, numDimensions)
% Normalize one query input per dimension.
if numel(queryInputs) ~= numDimensions
    error('TensorSpline:InvalidEvaluationInput',  'Supply exactly one query input per spline dimension.');
end

validateattributes(queryInputs{1}, {'numeric'}, {'real'});
outputSize = size(queryInputs{1});
numPoints = numel(queryInputs{1});
pointMatrix = zeros(numPoints, numDimensions);
for iDim = 1:numDimensions
    validateattributes(queryInputs{iDim}, {'numeric'}, {'real'});
    if ~isequal(size(queryInputs{iDim}), outputSize)
        error('TensorSpline:InvalidQueryArrays',  'All query inputs must have the same size.');
    end
    pointMatrix(:,iDim) = queryInputs{iDim}(:);
end
