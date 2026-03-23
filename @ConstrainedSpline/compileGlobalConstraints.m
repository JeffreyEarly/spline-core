function [Aineq, bineq] = compileGlobalConstraints(globalConstraints, tKnot, K)
% Compile global constraints into coefficient inequalities.
basisSize = reshape(cellfun(@numel, tKnot), 1, []) - reshape(K, 1, []);
numCoefficients = prod(basisSize);
Aineq = sparse([], [], [], 0, numCoefficients);
bineq = zeros(0,1);

for iConstraint = 1:numel(globalConstraints)
    constraint = globalConstraints(iConstraint);
    switch constraint.shape
        case GlobalConstraint.positiveShape
            constraintMatrix = -speye(numCoefficients);
        case GlobalConstraint.monotonicIncreasingShape
            constraintMatrix = ConstrainedSpline.monotonicDifferenceMatrix(basisSize, constraint.dimension, "increasing");
        case GlobalConstraint.monotonicDecreasingShape
            constraintMatrix = ConstrainedSpline.monotonicDifferenceMatrix(basisSize, constraint.dimension, "decreasing");
        otherwise
            error('ConstrainedSpline:UnsupportedGlobalConstraint',  'Unsupported global constraint shape.');
    end

    Aineq = [Aineq; constraintMatrix];
    bineq = [bineq; zeros(size(constraintMatrix,1),1)];
end
