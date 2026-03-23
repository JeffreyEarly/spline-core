function values = feval(spline, varargin)
% Evaluate a Voronoi spline at the supplied points.
%
% ```matlab
% values = feval(spline, xq);
% values2D = feval(spline, Xq, Yq);
% ```
%
% - Topic: Evaluate the spline
% - Declaration: values = feval(spline,varargin)
% - Parameter spline: VoronoiSpline instance
% - Parameter varargin: query locations and optional derivative orders
% - Returns values: spline values
arguments
    spline (1,1) VoronoiSpline
end
arguments (Repeating)
    varargin
end

values = spline.valueAtPoints(varargin{:});
