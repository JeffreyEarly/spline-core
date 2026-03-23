function [pointConstraints, globalConstraints] = normalizeConstraintInputs(constraints, numDimensions)
% Normalize mixed constraint inputs into separate arrays.
if isempty(constraints)
    pointConstraints = PointConstraint.empty(0,1);
    globalConstraints = GlobalConstraint.empty(0,1);
    return;
end

if ~isa(constraints, 'SplineConstraint')
    error('ConstrainedSpline:InvalidConstraints',  'constraints must be a SplineConstraint array.');
end

constraints = reshape(constraints, [], 1);
isPointConstraint = arrayfun(@(constraint) isa(constraint, 'PointConstraint'), constraints);
if any(isPointConstraint)
    pointConstraints = reshape([constraints(isPointConstraint)], [], 1);
else
    pointConstraints = PointConstraint.empty(0,1);
end

if any(~isPointConstraint)
    globalConstraints = reshape([constraints(~isPointConstraint)], [], 1);
else
    globalConstraints = GlobalConstraint.empty(0,1);
end

for iConstraint = 1:numel(pointConstraints)
    if ~isempty(numDimensions) && pointConstraints(iConstraint).numDimensions ~= numDimensions
        error('ConstrainedSpline:PointConstraintDimensionMismatch',  'Each point constraint must match the spline dimensionality.');
    end
end

for iConstraint = 1:numel(globalConstraints)
    if ~isempty(numDimensions) && ~isempty(globalConstraints(iConstraint).dimension) && globalConstraints(iConstraint).dimension > numDimensions
        error('ConstrainedSpline:GlobalConstraintDimensionMismatch',  'Global constraint dimensions must not exceed the spline dimensionality.');
    end
end
