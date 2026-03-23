function x = leftSolve(A, b)
% Solve a linear system, falling back to a pseudoinverse if needed.
if isempty(A)
    x = zeros(size(b));
    return;
end

if issparse(A)
    x = A\b;
    return;
end

reciprocalCondition = rcond(A);
if reciprocalCondition < eps(class(A))
    x = pinv(A) * b;
else
    x = A\b;
end
