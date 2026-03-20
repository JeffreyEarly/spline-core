function values = feval(spline,x)
% Evaluate a B-spline at the supplied points.
%
% This is equivalent to `spline(x)` and is useful when you prefer an
% explicit function-call form.
%
% ```matlab
% values = feval(spline, tQuery);
% ```
%
% - Topic: Evaluate the spline
% - Declaration: values = feval(spline,x)
% - Parameter spline: BSpline instance
% - Parameter x: evaluation points
% - Returns values: spline values with the same shape as x
arguments
    spline (1,1) BSpline
    x {mustBeNumeric,mustBeReal}
end
values = spline.valueAtPoints(x);
