function values = feval(spline, X, options)
% Evaluate a tensor spline at the supplied points.
%
% This is a thin wrapper around `valueAtPoints(...)`.
%
% ```matlab
% values = feval(spline, xq, yq);
% ```
%
% - Topic: Evaluate the spline
% - Declaration: values = feval(spline,X1,...,Xn,options)
% - Parameter spline: TensorSpline instance
% - Parameter X1,...,Xn: matching-size query locations as one array per dimension
% - Parameter options.D: derivative order per dimension
% - Returns values: spline values with the same shape as the query input
arguments
    spline (1,1) TensorSpline
end
arguments (Repeating)
    X {mustBeNumeric,mustBeReal}
end
arguments
    options.D {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger,mustBeNonnegative} = 0
end

values = spline.valueAtPoints(X{:}, D=options.D);
