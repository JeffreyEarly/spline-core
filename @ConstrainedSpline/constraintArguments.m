function [constraintArguments, constrainedValues] = constraintArguments(constraints, sampleValues, options)
% Normalize mixed constraint inputs into constructor arguments.
%
% - Topic: Methodology (Static methods)
% - Developer: true
% - Declaration: [constraintArguments,constrainedValues] = constraintArguments(constraints,sampleValues,options)
% - Parameter constraints: optional mixed SplineConstraint array
% - Parameter sampleValues: optional vector used for positivity heuristics
% - Parameter options.enforcePositiveIfPossible: add positivity when sampleValues are nonnegative
% - Returns constraintArguments: name-value arguments for constructor constraints
% - Returns constrainedValues: possibly clipped sample values
arguments
    constraints = []
    sampleValues (:,1) double = zeros(0,1)
    options.enforcePositiveIfPossible (1,1) logical = false
    options.numDimensions = []
end

[pointConstraints, globalConstraints] = ConstrainedSpline.normalizeConstraintInputs(constraints, options.numDimensions);
constrainedValues = sampleValues;

if options.enforcePositiveIfPossible && isempty(globalConstraints) && all(isfinite(constrainedValues)) && all(constrainedValues >= -10*eps(max(1, max(abs(constrainedValues)))))
    globalConstraints = GlobalConstraint.positive();
    constrainedValues = max(constrainedValues, 0);
end

if isempty(pointConstraints) && isempty(globalConstraints)
    constraintArguments = {};
    return;
end

constraintArguments = {'constraints', [pointConstraints; globalConstraints]};
