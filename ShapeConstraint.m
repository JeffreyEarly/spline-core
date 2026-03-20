classdef ShapeConstraint
    % Enumerate supported global shape constraints for constrained splines.
    %
    % These values are interpreted by ConstrainedSpline when constructing
    % global inequality constraints on spline coefficients.
    %
    % - Topic: Utility
    % - Declaration: classdef ShapeConstraint
    enumeration
        none
        positive
        monotonicIncreasing
        monotonicDecreasing
    end    
end
