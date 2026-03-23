function K = resolveSplineOrders(K, S, numDimensions, errorPrefix)
% Resolve mutually exclusive spline order and degree inputs.
if isempty(S) || (isscalar(S) && isnan(S))
    K = TensorSpline.normalizeOrders(K, numDimensions);
    return;
end

validateattributes(S, {'numeric'}, {'vector','real','finite','nonnegative','integer'});
if ~(isscalar(K) && K == 4)
    error(errorPrefix + ":ConflictingSplineOrder",  'Specify either K or S, but not both.');
end

K = TensorSpline.normalizeOrders(S + 1, numDimensions);
