%% Tutorial Metadata
% Title: Scattered Data Fitting in 2D
% Slug: scattered-data-fitting-2d
% Description: Fit a tensor-product spline to scattered two-dimensional observations and use dataDOF to control knot density in each coordinate direction.
% NavOrder: 7

%% Fit a tensor spline to scattered observations
% `InterpolatingSpline` in higher dimensions expects values on a
% rectilinear tensor grid, while scattered observations use
% `ConstrainedSpline.fromPoints`. That makes it the right entry point for
% noisy scattered observations in two dimensions.
%
% The tensor basis is still separable by coordinate direction, so we choose
% one knot vector for `x` and one for `y`. The helper
% `BSpline.knotPointsForDataPoints(..., dataDOF=...)` is useful here:
% increasing `dataDOF` thins the sorted sample coordinates before knot
% placement, producing fewer splines per dimension and therefore a
% smoother, cheaper fit.

rng(11)
numObservations = 450;
P = -2 + 4*rand(numObservations, 2);

truth = @(x, y)  1.1*exp(-((x+0.8).^2 + 1.3*(y-0.4).^2)) -  0.8*exp(-1.8*((x-0.7).^2 + 0.7*(y+0.5).^2)) +  0.2*x.*y;

zTrue = truth(P(:,1), P(:,2));
zObs = zTrue + 0.06*randn(size(zTrue));

K = [4 4];
denseDOF = [22 22];
coarseDOF = [30 30];

denseTKnot = {
    BSpline.knotPointsForDataPoints(P(:,1), K=K(1), dataDOF=denseDOF(1))
    BSpline.knotPointsForDataPoints(P(:,2), K=K(2), dataDOF=denseDOF(2))
    };
coarseTKnot = {
    BSpline.knotPointsForDataPoints(P(:,1), K=K(1), dataDOF=coarseDOF(1))
    BSpline.knotPointsForDataPoints(P(:,2), K=K(2), dataDOF=coarseDOF(2))
    };

denseFit = ConstrainedSpline.fromPoints(P, zObs, K=K, tKnot=denseTKnot);
coarseFit = ConstrainedSpline.fromPoints(P, zObs, K=K, tKnot=coarseTKnot);

denseBasisSize = cellfun(@numel, denseTKnot).' - K;
coarseBasisSize = cellfun(@numel, coarseTKnot).' - K;

fitDomain = denseFit.domain;
xq = linspace(fitDomain(1,1), fitDomain(1,2), 121)';
yq = linspace(fitDomain(2,1), fitDomain(2,2), 131)';
[Xq, Yq] = ndgrid(xq, yq);
Ztrue = truth(Xq, Yq);
Zdense = denseFit(Xq, Yq);
Zcoarse = coarseFit(Xq, Yq);

figure(Position=[100 100 1080 360])
tiledlayout(1, 3, TileSpacing="compact")

nexttile
scatter(P(:,2), P(:,1), 20, zObs, "filled")
axis equal tight
colorbar
xlabel("y")
ylabel("x")
title("Scattered observations")

nexttile
imagesc(yq, xq, Zdense)
axis xy equal tight
colorbar
xlabel("y")
ylabel("x")
title(sprintf("Fit with dataDOF = [%d %d]", denseDOF(1), denseDOF(2)))

nexttile
imagesc(yq, xq, Zcoarse)
axis xy equal tight
colorbar
xlabel("y")
ylabel("x")
title(sprintf("Fit with dataDOF = [%d %d]", coarseDOF(1), coarseDOF(2)))

if exist("tutorialFigureCapture", "var") && isa(tutorialFigureCapture, "function_handle"), tutorialFigureCapture("scattered-fit-fields", Caption="ConstrainedSpline fits a tensor-product surface directly to scattered 2D observations. The per-dimension dataDOF choice controls the knot density and therefore the flexibility of the fitted field."); end

%% Compare dense and coarse knot choices on a transect
% The denser fit uses more splines per coordinate direction, while the
% coarser fit uses fewer. Both are built from the same scattered
% observations; only the per-dimension knot density changes.

xTransect = linspace(fitDomain(1,1), fitDomain(1,2), 400)';
yTransect = zeros(size(xTransect));

zTransectTrue = truth(xTransect, yTransect);
zTransectDense = denseFit(xTransect, yTransect);
zTransectCoarse = coarseFit(xTransect, yTransect);

figure(Position=[100 100 820 340])
plot(xTransect, zTransectTrue, "k--", LineWidth=1.5), hold on
plot(xTransect, zTransectDense, LineWidth=2)
plot(xTransect, zTransectCoarse, LineWidth=2)
xlabel("x")
ylabel("z(x, 0)")
legend(  "Truth",  sprintf("dataDOF [%d %d], basis [%d %d]", denseDOF(1), denseDOF(2), denseBasisSize(1), denseBasisSize(2)),  sprintf("dataDOF [%d %d], basis [%d %d]", coarseDOF(1), coarseDOF(2), coarseBasisSize(1), coarseBasisSize(2)),  Location="southoutside")
grid on

if exist("tutorialFigureCapture", "var") && isa(tutorialFigureCapture, "function_handle"), tutorialFigureCapture("scattered-fit-transect", Caption="Larger dataDOF produces fewer splines per coordinate direction, which reduces model size and yields a smoother scattered-data fit."); end

%% Use dataDOF when the raw coordinate cloud is too dense
% For scattered 2D fitting, `dataDOF` is often more practical than
% building knot vectors from every observed coordinate value. The pattern
% is
%
% ```matlab
% tKnot = {
%     BSpline.knotPointsForDataPoints(P(:,1), K=4, dataDOF=22)
%     BSpline.knotPointsForDataPoints(P(:,2), K=4, dataDOF=22)
%     };
%
% fit = ConstrainedSpline.fromPoints(P, zObs, K=[4 4], tKnot=tKnot);
% ```
%
% where `P` is the `N x 2` observation matrix. The same idea extends to
% higher dimensions: choose one knot vector per coordinate direction, then
% fit a tensor-product model to the scattered observations.
