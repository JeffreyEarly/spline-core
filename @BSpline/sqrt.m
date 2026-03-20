function splinesqrt = sqrt(spline,constraints)
% Return a spline approximation to the square root of the spline output.
%
% - Topic: Operations
% - Declaration: splinesqrt = sqrt(spline,constraints)
% - Parameter spline: BSpline instance
% - Parameter constraints: optional constraint specification for the refit
% - Returns splinesqrt: BSpline approximating sqrt(spline)
arguments
    spline (1,1) BSpline
    constraints = []
end
if ~isempty(constraints)
    splinesqrt = power(spline,1/2,constraints);
else
    splinesqrt = power(spline,1/2);
end
