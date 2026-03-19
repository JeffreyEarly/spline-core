function splinesqrt = sqrt(spline,constraints)
% square-root of a BSpline
%
% - Topic: Operations
if exist('constraints','var')
    splinesqrt = power(spline,1/2,constraints);
else
    splinesqrt = power(spline,1/2);
end

