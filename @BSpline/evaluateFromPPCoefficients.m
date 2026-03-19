function f = evaluateFromPPCoefficients(t,C,tpp, D)
% Returns the value of the function with derivative D represented by PP coefficients C at locations t.
%
% - Topic: Spline evalutation
% - Declaration: f = evaluateFromPPCoefficients(t,C,tpp, D)
% - Parameter t: points at which to evaluate the splines
% - Parameter C: polynomial coefficients to be used in polyval, size(C) = [length(t_pp)-1, K]
% - Parameter tpp: piece-wise polynomial intervals, size(tpp) = length(tKnot) - 2*K + 1
% - Parameter D: number of derivatives
% - Returns f: vector the same size as t

if issorted(t,'ascend')
    didFlip = 0;
elseif issorted(t,'descend')
    t = flip(t);
    didFlip = 1;
else
    error('Not sorted')
    [t,I] = sort(t);
    d = 1:length(t);
    returnIndices = d(I);
    didFlip = 2;
end

K = size(C,2);
f = zeros(size(t));

if nargin < 4
    D = 0;
elseif D > K-1
    % By construction the splines are zero for K or more derivs
    return;
end

scale = factorial((K-1-D):-1:0);
indices = 1:(K-D);

% startIndex and endIndex are indices into t/f
%             startIndex = 1;
%             for i=2:length(t_pp)
%                 endIndex = find(t <= t_pp(i),1,'last');
%                 f(startIndex:endIndex) = polyval(C(i-1,indices)./scale,t(startIndex:endIndex)-t_pp(i-1));
%                 startIndex = endIndex+1;
%             end
%             f(startIndex:end) = polyval(C(i-1,indices)./scale,t(startIndex:end)-t_pp(i-1));

% The above implementation is faster, but doesn't actually work in some
% cases, like evaluating a single point. The discretize function is slow.
t_pp_bin = discretize(t,[-Inf; tpp(2:end-1); Inf]);
startIndex = 1;
while startIndex <= length(t)
    iBin = t_pp_bin(startIndex);
    endIndex = find( t_pp_bin == iBin, 1, 'last');
    f(startIndex:endIndex) = polyval(C(iBin,indices)./scale,t(startIndex:endIndex)-tpp(iBin));
    startIndex = endIndex+1;
end

% include an extrapolated points past the end.
if startIndex <= length(t)
    f(startIndex:end) = polyval(C(iBin,indices)./scale,t(startIndex:end)-tpp(iBin));
end

if didFlip == 0
    return;
elseif didFlip == 1
    f = flip(f);
else
    f = f(returnIndices);
end
end