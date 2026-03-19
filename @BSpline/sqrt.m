function splinesqrt = sqrt(spline,constraints)
% square-root of a BSpline
%
% - Topic: Operations
arguments
    spline (1,1) BSpline
    constraints = []
end
if ~isempty(constraints)
    splinesqrt = power(spline,1/2,constraints);
else
    splinesqrt = power(spline,1/2);
end
