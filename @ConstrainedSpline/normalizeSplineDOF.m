function splineDOF = normalizeSplineDOF(splineDOF, numDimensions)
% Normalize splineDOF to one value per dimension.
if isempty(splineDOF)
    return;
end

validateattributes(splineDOF, {'numeric'}, {'vector','real','finite','integer','positive'});
if isscalar(splineDOF)
    splineDOF = repmat(splineDOF, 1, numDimensions);
    return;
end

splineDOF = reshape(splineDOF, 1, []);
if numel(splineDOF) ~= numDimensions
    error('ConstrainedSpline:InvalidDegreeOfFreedomOption', 'splineDOF must be scalar or have one element per dimension.');
end
