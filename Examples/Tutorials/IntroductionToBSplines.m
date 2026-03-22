%% Tutorial Metadata
% Title: Introduction to B-splines
% Slug: introduction-to-b-splines
% Description: Build intuition for spline order, knot placement, interpolation, and B-spline basis functions through the first two canonical spline figures.
% NavOrder: 2

%% Interpolate the same samples with increasing spline order
% This tutorial reproduces the two introductory spline figures from the
% interpolation paper that motivated this package:
% [Interpolation with tension](https://journals.ametsoc.org/view/journals/atot/37/3/JTECH-D-19-0087.1.xml).
%
% We start with seven exact samples $(t_i, x_i)$ and build interpolants of
% order $K = 1, 2, 3, 4$. In this package the degree is
% $S = K - 1$, so these correspond to piecewise constant, piecewise
% linear, quadratic, and cubic interpolants.
%
% The constructor
% `InterpolatingSpline(t, x, K=K)` chooses the canonical terminated knot
% sequence for the requested order and solves for the coefficients that
% force the spline to pass through all observations. If you want to see or
% reuse those canonical knots yourself, the lower-level entry point is
% `BSpline.knotPointsForDataPoints(tData, K=K)`.

tData = 2*pi*2.5*[0; 1; 3; 4; 5; 8; 10]/10;
xData = sin(tData);
tQuery = linspace(tData(1), tData(end), 1000)';

maxK = 4;
valueLimits = [-1.5 1.5];
derivativeTitles = ["Value", "1st derivative", "2nd derivative", "3rd derivative"];

figure(Position=[100 100 1120 760])
tiledlayout(maxK, maxK, TileSpacing="compact", Padding="compact")

for K = 1:maxK
    splineFit = InterpolatingSpline(tData, xData, K=K);
    knotLocations = unique(splineFit.tKnot);

    for derivativeOrder = 0:maxK-1
        nexttile

        if derivativeOrder >= K
            axis off
            continue
        end

        hold on
        for knotValue = knotLocations(:).'
            xline(knotValue, ":", Color=0.7*[1 1 1], LineWidth=0.8);
        end

        plot(tQuery, splineFit(tQuery, derivativeOrder), "k", LineWidth=1.5)
        xlim([min(tData), max(tData)])
        ylim(valueLimits)
        grid on
        set(gca, YTick=[], Box="on")

        if derivativeOrder == 0
            scatter(tData, xData, 28, "filled", MarkerFaceColor="k", MarkerEdgeColor="k")
        end

        if K == 1
            title(derivativeTitles(derivativeOrder + 1))
        end

        if derivativeOrder == 0
            ylabel(sprintf("K = %d", K))
        else
            set(gca, YColor="none")
        end

        if K < maxK
            set(gca, XTickLabel=[])
        else
            xlabel("t")
        end
    end
end

if exist("tutorialFigureCapture", "var") && isa(tutorialFigureCapture, "function_handle"), tutorialFigureCapture("interpolating-splines-by-order", Caption="InterpolatingSpline applied to the same seven observations for orders K = 1 through 4. Rows show spline order, columns show the spline and its nonzero derivatives. The vertical gray lines mark knot locations."); end

%% Interpret the first figure
% The top row is nearest-neighbor interpolation. It is piecewise constant,
% so only the value itself is nonzero. For $K = 2$, the spline becomes
% piecewise linear and its first derivative is piecewise constant. Higher
% orders add one more level of continuity and one more nonzero derivative.
%
% In other words, the order controls both the local polynomial degree and
% how smoothly adjacent pieces connect:
%
% $$S = K - 1$$
%
% The knot sequence changes with $K$ because the package uses the canonical
% interpolating construction for each order. That keeps the number of basis
% functions aligned with the number of observations while still enforcing
% exact interpolation.

%% Connect the figure to the BSpline API
% `InterpolatingSpline` is the high-level interface, but the underlying
% building blocks are public on `BSpline`.
%
% Use `BSpline.knotPointsForDataPoints` to construct the canonical knot
% sequence, `BSpline.matrix` to assemble the design matrix, and the
% `BSpline` constructor when you want to work with a basis expansion
% directly.

canonicalOrder = 4;
canonicalTKnot = BSpline.knotPointsForDataPoints(tData, K=canonicalOrder);
canonicalBasis = BSpline.matrix(tData, canonicalTKnot, canonicalOrder);
canonicalSpline = BSpline(canonicalOrder, canonicalTKnot, canonicalBasis \ xData);

canonicalTKnot

%% Compare the direct BSpline construction with InterpolatingSpline
% The two paths below are equivalent in one dimension. The first is the
% convenience constructor, and the second exposes the underlying
% `BSpline` calls explicitly.

directInterpolant = InterpolatingSpline(tData, xData, K=canonicalOrder);
maxDifference = max(abs(directInterpolant(tQuery) - canonicalSpline(tQuery)));
maxDifference

%% Build a single B-spline basis function and its derivatives
% The interpolants above are linear combinations of B-spline basis
% functions. A first-order B-spline is the rectangle function
%
% $$X_m^1(t) =
% \begin{cases}
% 1, & \tau_m \le t < \tau_{m+1}, \\
% 0, & \text{otherwise},
% \end{cases}$$
%
% and higher orders are generated recursively by the Cox-de Boor formula
%
% $$X_m^K(t) =
% \frac{t - \tau_m}{\tau_{m+K-1} - \tau_m} X_m^{K-1}(t) +
% \frac{\tau_{m+K} - t}{\tau_{m+K} - \tau_{m+1}} X_{m+1}^{K-1}(t).$$
%
% To visualize the basis directly, we keep one irregular knot sequence
% fixed and activate a single coefficient in a `BSpline` object. This is
% the same object you would get after solving against `BSpline.matrix`,
% except here we choose the coefficients by hand to isolate one basis
% function.

tSupport = [0; 1; 3; 4; 5; 8; 10];
tPlot = linspace(0, 10, 1000)';
basisLimits = [-2 2];
basisTitles = ["Value", "1st derivative", "2nd derivative", "3rd derivative"];
iSpline = 2;

figure(Position=[100 100 1120 760])
tiledlayout(maxK, maxK, TileSpacing="compact", Padding="compact")

for K = 1:maxK
    tKnot = [repmat(tSupport(1), K-1, 1); tSupport; repmat(tSupport(end), K-1, 1)];
    coefficients = zeros(numel(tSupport) + K - 2, 1);
    coefficients(iSpline + K - 1) = 1;
    basisSpline = BSpline(K, tKnot, coefficients);

    for derivativeOrder = 0:maxK-1
        nexttile

        if derivativeOrder >= K
            axis off
            continue
        end

        hold on
        for knotValue = unique(tSupport(:)).'
            xline(knotValue, ":", Color=0.7*[1 1 1], LineWidth=0.8);
        end

        plot(tPlot, basisSpline(tPlot, derivativeOrder), "k", LineWidth=1.5)
        xlim([min(tSupport), max(tSupport)])
        ylim(basisLimits)
        grid on
        set(gca, YTick=[], Box="on")

        if K == 1
            title(basisTitles(derivativeOrder + 1))
        end

        if derivativeOrder == 0
            ylabel(sprintf("K = %d", K))
        else
            set(gca, YColor="none")
        end

        if K < maxK
            set(gca, XTickLabel=[])
        else
            xlabel("t")
        end
    end
end

if exist("tutorialFigureCapture", "var") && isa(tutorialFigureCapture, "function_handle"), tutorialFigureCapture("bspline-basis-and-derivatives", Caption="One B-spline basis function and its derivatives for orders K = 1 through 4. Each increase in order broadens the support and raises the continuity by one derivative."); end

%% Interpret the basis functions
% The first-order basis function is compactly supported on one knot
% interval. Each increase in order extends the support across one more knot
% interval and makes the basis smoother. That is the key reason B-splines
% are useful: they are local, but they still build smooth global curves
% when combined through a coefficient vector $\xi$:
%
% $$x(t) = \sum_m X_m^K(t)\,\xi^m.$$
%
% The interpolation problem is therefore reduced to choosing knot
% locations, assembling the basis matrix, and solving for the coefficients
% that reproduce the observed samples.
