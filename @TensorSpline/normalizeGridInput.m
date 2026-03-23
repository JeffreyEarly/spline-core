function [gridVectors, numDimensions] = normalizeGridInput(grid, errorPrefix)
% Normalize grid input to a 1-by-D cell array of column vectors.
errorPrefix = string(errorPrefix);

if iscell(grid)
    if isempty(grid)
        error(errorPrefix + ":InvalidGrid", 'grid must not be empty.');
    end

    numDimensions = numel(grid);
    gridVectors = reshape(grid, 1, []);
    for iDim = 1:numDimensions
        validateattributes(gridVectors{iDim}, {'numeric'}, {'vector','real','finite'});
        gridVectors{iDim} = reshape(gridVectors{iDim}, [], 1);
    end
    return;
end

validateattributes(grid, {'numeric'}, {'vector','real','finite'});
numDimensions = 1;
gridVectors = {reshape(grid, [], 1)};
