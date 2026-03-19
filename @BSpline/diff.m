function dspline = diff(spline,n)
% differentiation of a BSpline
%
% - Topic: Operations

if nargin < 2
    n = 1;
end

if n == 0
    dspline = spline;
elseif n >= spline.K
    dspline = BSpline(1,reshape(spline.domain,[],1),0);
elseif ( ( n > 0 ) && ( round(n) == n ) )   % Positive integer
    D = n;
    xi = spline.xi;
    K = spline.K;
    tKnot = spline.tKnot;
    M = length(xi);
    
    alpha = zeros(length(xi),D+1);
    alpha(:,1) = xi; % first column is the existing coefficients
    
    for d=1:D
        dm = diff(alpha(:,d));
        dt = (tKnot(1+K-d:M+K-d)-tKnot(1:M))/(K-d);
        alpha(1:end-d,d+1) = dm./dt(d+1:end);
    end
    
    dspline = BSpline(K-D,tKnot((1+D):(end-D)),alpha(1:end-D,D+1));
    dspline.x_std = spline.x_std;   
else
    error('Can only differentiate with positive integers');
end
