function A = monotonicDifferenceMatrix(basisSize, dim, direction)
% Build coefficient-difference inequalities along one dimension.
basisSize = reshape(basisSize, 1, []);
numCoefficients = prod(basisSize);
if isscalar(basisSize)
    basisSize = [basisSize, 1];
end
coefficientGrid = reshape(1:numCoefficients, basisSize);

lowerSubscripts = repmat({':'}, 1, numel(basisSize));
upperSubscripts = lowerSubscripts;
lowerSubscripts{dim} = 1:(basisSize(dim)-1);
upperSubscripts{dim} = 2:basisSize(dim);

lowerIndex = coefficientGrid(lowerSubscripts{:});
upperIndex = coefficientGrid(upperSubscripts{:});
lowerIndex = lowerIndex(:);
upperIndex = upperIndex(:);
numRows = numel(lowerIndex);

switch string(direction)
    case "increasing"
        rowValues = [ones(numRows,1); -ones(numRows,1)];
    case "decreasing"
        rowValues = [-ones(numRows,1); ones(numRows,1)];
    otherwise
        error('ConstrainedSpline:InvalidMonotonicDirection',  'direction must be "increasing" or "decreasing".');
end

rowIndex = [(1:numRows)'; (1:numRows)'];
columnIndex = [lowerIndex; upperIndex];
A = sparse(rowIndex, columnIndex, rowValues, numRows, numCoefficients);
