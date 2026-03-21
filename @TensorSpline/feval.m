function values = feval(spline, varargin)
% Evaluate a tensor spline at the supplied points.
%
% This is equivalent to `spline(...)` and is useful when you prefer an
% explicit function-call form.
%
% ```matlab
% values = feval(spline, xq, yq);
% ```
%
% - Topic: Evaluate the spline
% - Declaration: values = feval(spline,varargin)
% - Parameter spline: TensorSpline instance
% - Parameter varargin: query locations and optional derivative orders
% - Returns values: spline values with the same shape as the query input
arguments
    spline (1,1) TensorSpline
end
arguments (Repeating)
    varargin
end

values = spline.valueAtPoints(varargin{:});
