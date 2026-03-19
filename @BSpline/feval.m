function values = feval(spline,x)
% value of BSpline
%
% - Topic: Operations
arguments
    spline (1,1) BSpline
    x {mustBeNumeric,mustBeReal}
end
values = spline.valueAtPoints(x);
