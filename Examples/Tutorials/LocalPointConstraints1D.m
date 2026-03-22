%% Tutorial Metadata
% Title: Local Point Constraints in 1D
% Slug: local-point-constraints-1d
% Description: Apply value and derivative equality constraints at one or more points in a one-dimensional spline fit.
% NavOrder: 4

%% Start from one noisy one-dimensional fit
% Local constraints act at specific points. In one dimension they are the
% simplest way to say “the fitted curve must pass through this value here”
% or “the slope or curvature must vanish here.”
%
% We will use one noisy dataset and compare several constrained fits
% against the same unconstrained baseline.

rng(9)
t = linspace(0, 1, 32)';
xTrue = 0.2 + 0.45*sin(2*pi*t) + 0.18*cos(5*pi*t);
xObs = xTrue + 0.05*randn(size(t));

tKnot = linspace(min(t), max(t), 12)';
freeFit = ConstrainedTensorSpline(t, xObs, K=4, tKnot={tKnot});
tDense = linspace(min(t), max(t), 500)';
xFree = freeFit(tDense);

caseDefinitions = struct( ...
    "Title", { ...
        "Value at one point", ...
        "Zero slope at one point", ...
        "Zero curvature at one point", ...
        "Value and slope together", ...
        "Zero slope at two points"}, ...
    "Constraints", { ...
        PointConstraint.equal(0.42, Value=0.55), ...
        PointConstraint.equal(0.42, D=1, Value=0), ...
        PointConstraint.equal(0.68, D=2, Value=0), ...
        [PointConstraint.equal(0.42, Value=0.55); PointConstraint.equal(0.42, D=1, Value=0)], ...
        PointConstraint.equal([0.35; 0.55], D=1, Value=0)} ...
    );

constrainedFits = cell(size(caseDefinitions));
for iCase = 1:numel(caseDefinitions)
    constrainedFits{iCase} = ConstrainedTensorSpline(t, xObs, K=4, ...
        tKnot={tKnot}, ...
        pointConstraints=caseDefinitions(iCase).Constraints);
end

figure(Position=[100 100 980 860])
tiledlayout(3, 2, TileSpacing="compact", Padding="compact")

nexttile
plot(tDense, xFree, "--", LineWidth=1.8), hold on
scatter(t, xObs, 24, "filled", MarkerFaceAlpha=0.7)
grid on
xlabel("t")
ylabel("x(t)")
title("Unconstrained baseline")
ylim([min(xTrue)-0.25, max(xTrue)+0.25])
legend("Unconstrained fit", "Observations", Location="southoutside")

for iCase = 1:numel(caseDefinitions)
    nexttile
    plot(tDense, xFree, "--", LineWidth=1.5), hold on
    plot(tDense, constrainedFits{iCase}(tDense), LineWidth=2)
    scatter(t, xObs, 20, "filled", MarkerFaceAlpha=0.55)

    theseConstraints = caseDefinitions(iCase).Constraints;
    for iConstraint = 1:numel(theseConstraints)
        if all(theseConstraints(iConstraint).D == 0)
            scatter(theseConstraints(iConstraint).Points, theseConstraints(iConstraint).Value, ...
                55, "o", LineWidth=1.4, MarkerEdgeColor=[0.82 0.2 0.2])
        else
            for iPoint = 1:size(theseConstraints(iConstraint).Points, 1)
                xline(theseConstraints(iConstraint).Points(iPoint), ":", ...
                    Color=[0.82 0.2 0.2], LineWidth=1.3)
            end
        end
    end

    grid on
    xlabel("t")
    ylabel("x(t)")
    title(caseDefinitions(iCase).Title)
    ylim([min(xTrue)-0.25, max(xTrue)+0.25])
end

if exist("tutorialFigureCapture", "var") && isa(tutorialFigureCapture, "function_handle"), tutorialFigureCapture("local-constraint-cases", Caption="Several one-dimensional local equality constraints applied to the same noisy fit. Each panel compares the constrained fit against the unconstrained baseline."); end

%% Use derivative order D to choose what is constrained
% The `D` argument in `PointConstraint.equal(...)` specifies which
% derivative is constrained:
%
% - `D = 0` constrains the value
% - `D = 1` constrains the first derivative
% - `D = 2` constrains the second derivative
%
% A single fit can combine multiple local conditions. Here we enforce both
% a value and a zero-slope condition at the same point.

combinedFit = constrainedFits{4};
combinedValue = combinedFit(tDense);
combinedSlope = combinedFit(tDense, 1);
combinedCurvature = combinedFit(tDense, 2);
constraintPoint = 0.42;

figure(Position=[100 100 820 720])
tiledlayout(3, 1, TileSpacing="compact")

nexttile
plot(tDense, xFree, "--", LineWidth=1.6), hold on
plot(tDense, combinedValue, LineWidth=2.1)
scatter(t, xObs, 24, "filled", MarkerFaceAlpha=0.65)
scatter(constraintPoint, 0.55, 65, "o", LineWidth=1.5, MarkerEdgeColor=[0.82 0.2 0.2])
xline(constraintPoint, ":", Color=[0.82 0.2 0.2], LineWidth=1.2)
grid on
ylabel("Value")
title("Combine several local conditions in one fit")
legend("Unconstrained", "Constrained", "Observations", "Value target", ...
    Location="southoutside")

nexttile
plot(tDense, combinedSlope, LineWidth=2), hold on
yline(0, "k--")
xline(constraintPoint, ":", Color=[0.82 0.2 0.2], LineWidth=1.2)
grid on
ylabel("1st derivative")

nexttile
plot(tDense, combinedCurvature, LineWidth=2), hold on
yline(0, "k--")
xline(constraintPoint, ":", Color=[0.82 0.2 0.2], LineWidth=1.2)
grid on
xlabel("t")
ylabel("2nd derivative")

if exist("tutorialFigureCapture", "var") && isa(tutorialFigureCapture, "function_handle"), tutorialFigureCapture("combined-local-constraints", Caption="A value constraint and a zero-slope constraint can be imposed at the same point by combining PointConstraint objects."); end

%% Build local constraints with PointConstraint.equal
% In one dimension, the most common pattern is just
%
% ```matlab
% PointConstraint.equal(tc, Value=xc)
% PointConstraint.equal(tc, D=1, Value=0)
% PointConstraint.equal(tc, D=2, Value=0)
% ```
%
% or a vectorized version when the same type of condition should hold at
% several points:
%
% ```matlab
% PointConstraint.equal([t1; t2; t3], D=1, Value=0)
% ```
%
% Those constraint objects are then passed as the `pointConstraints`
% option to `ConstrainedTensorSpline`.
