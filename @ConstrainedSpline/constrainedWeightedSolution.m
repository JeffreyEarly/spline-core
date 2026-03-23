function [xi, systemMatrix] = constrainedWeightedSolution(normalMatrix, rhs, Aeq, beq, Aineq, bineq)
% Solve weighted least squares with optional linear constraints.
numCoefficients = size(normalMatrix, 1);

if isempty(Aeq)
    Aeq = zeros(0, numCoefficients);
    beq = zeros(0,1);
end

if isempty(Aineq)
    Aineq = zeros(0, numCoefficients);
    bineq = zeros(0,1);
end

if isempty(Aineq)
    if isempty(Aeq)
        xi = ConstrainedSpline.leftSolve(normalMatrix, rhs);
        systemMatrix = normalMatrix;
    else
        systemMatrix = [normalMatrix, Aeq'; Aeq, zeros(size(Aeq,1))];
        solution = ConstrainedSpline.leftSolve(systemMatrix, [rhs; beq]);
        xi = solution(1:numCoefficients);
    end
    return;
end

H = (normalMatrix + normalMatrix')*0.5;
options = optimoptions('quadprog', 'Display', 'off', 'Algorithm', 'interior-point-convex');
[xi, ~, exitflag] = quadprog(2*H, -2*rhs, Aineq, bineq, Aeq, beq, [], [], [], options);
if exitflag <= 0
    error('ConstrainedSpline:OptimizationFailed',  'The constrained tensor-spline fit failed to converge.');
end

systemMatrix = normalMatrix;
