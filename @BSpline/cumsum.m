function intspline = cumsum(spline)
% indefinite integral of a BSpline
%
% - Topic: Operations

xi = spline.xi;
K = spline.K;
tKnot = spline.tKnot;
M = length(xi);

if abs(spline.x_mean) > 0 || abs(spline.x_std - 1) > 0
%     X = spline.B(:,:,1);
%     if isempty(X)
%         X = BSpline.Spline( spline.t_pp, tKnot, K );
%     end
    t = BSpline.pointsOfSupport(spline.tKnot,spline.K);
    X = BSpline.matrix(t,spline.tKnot,spline.K);
    xi = spline.x_std*spline.xi + X\(spline.x_mean*ones(length(t),1));
end


dt = (tKnot(1+K:M+K)-tKnot(1:M))/K;
beta = zeros(length(xi)+1,1);
for i=2:length(beta)
   beta(i) = beta(i-1) + xi(i-1)*dt(i-1); 
end

tKnot = cat(1,spline.tKnot(1),spline.tKnot,spline.tKnot(end));
intspline = BSpline(spline.K+1,tKnot,beta);
% intspline.x_std = spline.x_std;
