classdef ShapeConstraint
    % Enumerate supported global shape constraints for constrained splines.
    %
    % These values are interpreted by ConstrainedSpline when constructing
    % global inequality constraints on spline coefficients.
    %
    % ## Basic usage
    %
    % Use these enumeration values when selecting a global shape
    % constraint for `ConstrainedSpline`.
    %
    % ```matlab
    % constraints.global = ShapeConstraint.monotonicIncreasing;
    % spline = ConstrainedSpline(t, x, 4, tKnot, [], constraints);
    % ```
    %
    % - Topic: Choose a shape constraint
    % - Declaration: classdef ShapeConstraint
    enumeration
        none
        positive
        monotonicIncreasing
        monotonicDecreasing
    end    
end
