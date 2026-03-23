function [Aeq, beq, Aineq, bineq] = compilePointConstraints(pointConstraints, tKnot, K)
% Compile point constraints into equality and inequality systems.
basisSize = reshape(cellfun(@numel, tKnot), 1, []) - reshape(K, 1, []);
numCoefficients = prod(basisSize);
Aeq = sparse([], [], [], 0, numCoefficients);
beq = zeros(0,1);
Aineq = sparse([], [], [], 0, numCoefficients);
bineq = zeros(0,1);

for iConstraint = 1:numel(pointConstraints)
    constraint = pointConstraints(iConstraint);
    [groupOrders, ~, groupIndex] = unique(constraint.D, 'rows', 'stable');
    for iGroup = 1:size(groupOrders, 1)
        isGroup = groupIndex == iGroup;
        B = sparse(TensorSpline.matrix(constraint.points(isGroup,:), tKnot, K - 1, D=groupOrders(iGroup,:)));
        values = constraint.value(isGroup);

        switch constraint.relation
            case PointConstraint.equalRelation
                Aeq = [Aeq; B];
                beq = [beq; values];
            case PointConstraint.lowerBoundRelation
                Aineq = [Aineq; -B];
                bineq = [bineq; -values];
            case PointConstraint.upperBoundRelation
                Aineq = [Aineq; B];
                bineq = [bineq; values];
            otherwise
                error('ConstrainedSpline:InvalidConstraintRelation',  'Unsupported point-constraint relation.');
        end
    end
end
