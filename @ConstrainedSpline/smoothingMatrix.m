function S = smoothingMatrix(self)
% Return the smoothing matrix that maps observations to fitted values.
%
% Use this to inspect the linear action of the final weighted
% fit on the observed data.
%
% ```matlab
% S = spline.smoothingMatrix();
% valuesFit = S * spline.values;
% ```
%
% - Topic: Analyze the fit
% - Declaration: S = smoothingMatrix(self)
% - Parameter self: ConstrainedSpline instance
% - Returns S: smoothing matrix
if ~isempty(self.Aeq) || ~isempty(self.Aineq)
    error('ConstrainedSpline:UnavailableSmoothingMatrix',  'smoothingMatrix is only available for unconstrained tensor fits.');
end

if size(self.W,1) == length(self.values) && size(self.W,2) == 1
    S = (self.X*ConstrainedSpline.leftSolve(self.CmInv, self.X.')).*(self.W.');
elseif isa(self.W, 'decomposition')
    S = self.X*ConstrainedSpline.leftSolve(self.CmInv, self.X.');
    S = (self.W \ S.').';
else
    S = (self.X*ConstrainedSpline.leftSolve(self.CmInv, self.X.'))*self.W;
end
