function tKnot = normalizeConstructorKnotCell(tKnot, numDimensions)
% Normalize constructor knot input to a knot cell or empty.
if isempty(tKnot)
    return;
end

if isnumeric(tKnot)
    validateattributes(tKnot, {'numeric'}, {'vector','real','finite'});
    if ~isempty(numDimensions) && numDimensions ~= 1
        error('ConstrainedSpline:InvalidKnotCell',  'tKnot must be a knot vector in 1-D or a cell array with one knot vector per dimension.');
    end
    tKnot = {reshape(tKnot, [], 1)};
    return;
end

if ~iscell(tKnot)
    error('ConstrainedSpline:InvalidKnotCell',  'tKnot must be a knot vector in 1-D or a cell array with one knot vector per dimension.');
end

if isempty(numDimensions)
    numDimensions = numel(tKnot);
end

tKnot = TensorSpline.normalizeKnotCell(tKnot, numDimensions);
