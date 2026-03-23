function tKnot = terminatedKnotPoints(tKnot, K)
% Ensure each knot vector has K repeated knots at its boundaries.
%
% Use this helper when you want to terminate a manually supplied
% knot sequence before fitting. In 1-D it accepts a numeric knot
% vector; in higher dimensions it accepts a cell array with one
% knot vector per dimension.
%
% ```matlab
% tKnot = ConstrainedSpline.terminatedKnotPoints(tKnot, 4);
% ```
%
% - Topic: Prepare knot sequences
% - Declaration: tKnot = terminatedKnotPoints(tKnot,K)
% - Parameter tKnot: knot vector in 1-D or cell array of knot vectors
% - Parameter K: spline order scalar or vector with one entry per dimension
% - Returns tKnot: terminated knot sequence
if isnumeric(tKnot)
    validateattributes(tKnot, {'numeric'}, {'vector','real','finite'});
    K = TensorSpline.normalizeOrders(K, 1);
    tKnot = reshape(tKnot, [], 1);

    nLeft = find(tKnot <= tKnot(1), 1, 'last');
    nRight = numel(tKnot) - find(tKnot == tKnot(end), 1, 'first') + 1;
    tKnot = [repmat(tKnot(1), K-nLeft, 1); tKnot; repmat(tKnot(end), K-nRight, 1)];
    return;
end

if ~iscell(tKnot)
    error('ConstrainedSpline:InvalidKnotCell',  'tKnot must be a knot vector in 1-D or a cell array with one knot vector per dimension.');
end

numDimensions = numel(tKnot);
K = TensorSpline.normalizeOrders(K, numDimensions);
tKnot = reshape(tKnot, 1, []);
for iDim = 1:numDimensions
    tKnot{iDim} = ConstrainedSpline.terminatedKnotPoints(tKnot{iDim}, K(iDim));
end
