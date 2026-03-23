function splineCoefficientsDidChange(self)
% Refresh cached polynomial coefficients after coefficient updates.
%
% - Topic: Maintain cached state
% - Developer: true
% - Declaration: splineCoefficientsDidChange(self)
% - Parameter self: BSpline instance
if isempty(self.xi_)
    self.C = [];
    self.t_pp = [];
    self.Xtpp = [];
    return;
end
[self.C,self.t_pp,self.Xtpp] = BSpline.ppCoefficientsFromSplineCoefficients(self.xi_, self.tKnot_, self.K, Xtpp=self.Xtpp);
