function values = feval(spline,x)
% Evaluate a B-spline at the supplied points.
%
% - Topic: Operations
% - Declaration: values = feval(spline,x)
% - Parameter spline: BSpline instance
% - Parameter x: evaluation points
% - Returns values: spline values with the same shape as x
arguments
    spline (1,1) BSpline
    x {mustBeNumeric,mustBeReal}
end
values = spline.valueAtPoints(x);
