function x_out = valueAtPoints(self, t, NumDerivatives)
% Evaluate the spline or one of its derivatives at arbitrary points.
%
% This is the main explicit evaluation method. Pass
% `NumDerivatives = 0` for spline values, `1` for the first
% derivative, and so on.
%
% ```matlab
% x = spline.valueAtPoints(tQuery);
% d2x = spline.valueAtPoints(tQuery, 2);
% ```
%
% - Topic: Evaluate the spline
% - Declaration: x_out = valueAtPoints(self,t,NumDerivatives)
% - Parameter self: BSpline instance
% - Parameter t: evaluation points
% - Parameter NumDerivatives: derivative order to evaluate
% - Note: derivative orders above K-1 evaluate to zero.
% - Returns x_out: array matching the shape of t
arguments
    self (1,1) BSpline
    t {mustBeNumeric,mustBeReal}
    NumDerivatives (1,1) double {mustBeInteger,mustBeNonnegative} = 0
end

if NumDerivatives > self.K-1
    x_out = zeros(size(t), 'like', t);
    return;
end
x_out = BSpline.evaluateFromPPCoefficients(t,self.C,self.t_pp,NumDerivatives);
if ~isempty(self.xStd)
    x_out = self.xStd*x_out;
end
if ~isempty(self.xMean) && NumDerivatives == 0
    x_out = x_out + self.xMean;
end
