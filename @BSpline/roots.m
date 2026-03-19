function values = roots(spline)
% roots of BSpline for its domain
%
% - Topic: Operations
arguments
    spline (1,1) BSpline
end
values = [];
scale = factorial((spline.K-1):-1:0);
C = spline.x_std*spline.C;
C(:,end) = C(:,end) + spline.x_mean;
t_pp = spline.t_pp;

for iBin=1:size(spline.C,1)
    localRoots = roots(C(iBin,:)./scale);
    intervalWidth = t_pp(iBin+1) - t_pp(iBin);
    isValidRoot = imag(localRoots) == 0 & real(localRoots) >= 0 & real(localRoots) <= intervalWidth;
    if any(isValidRoot)
        values = cat(1,values,real(localRoots(isValidRoot)) + t_pp(iBin));
    end
end

values = sort(values);
