function validateGridValues(values, gridVectors, errorPrefix)
% Validate sampled values against a rectilinear grid shape.
errorPrefix = string(errorPrefix);
validateattributes(values, {'numeric'}, {'real','finite'});

expectedSize = cellfun(@numel, gridVectors);
if numel(expectedSize) == 1
    if ~(isvector(values) && numel(values) == expectedSize(1))
        error(errorPrefix + ":SizeMismatch",  'values must have size matching the lengths of the supplied grid inputs.');
    end
    return;
end

actualSize = size(values);
if numel(actualSize) < numel(expectedSize)
    actualSize = [actualSize, ones(1, numel(expectedSize) - numel(actualSize))];
end

if ~isequal(actualSize(1:numel(expectedSize)), expectedSize)
    error(errorPrefix + ":SizeMismatch",  'values must have size matching the lengths of the supplied grid inputs.');
end
