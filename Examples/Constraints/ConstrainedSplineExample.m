% ConstrainedSplineExample
%
% Explore how knot placement and local derivative constraints change a
% one-dimensional fit. Set `exampleCase` to one of:
%
% 1. default unconstrained fit
% 2. transition knots with local plateau/acceleration constraints
% 3. wider transition knots with the same constraints
% 4. single midpoint break with the same constraints
% 5. repeated midpoint knots with the same constraints
% 6. repeated transition knots with the same constraints

exampleCase = 6;

t = (0:10)';
x = [0; 0; 0; 0; 0; 0; 2; 4; 6; 8; 10];
tq = linspace(min(t), max(t), 1000)';

K = 3;
distribution = NormalDistribution(1);

selectedCase = caseSpecification(exampleCase);
defaultSpline = ConstrainedSpline(t, x, K=K, distribution=distribution);

selectedFreeSpline = [];
selectedConstrainedSpline = [];
if ~isempty(selectedCase.tKnot)
    selectedFreeSpline = ConstrainedSpline(t, x, ...
        K=K, ...
        tKnot=selectedCase.tKnot, ...
        distribution=distribution);
end
if ~isempty(selectedCase.pointConstraints)
    selectedConstrainedSpline = ConstrainedSpline(t, x, ...
        K=K, ...
        tKnot=selectedCase.tKnot, ...
        distribution=distribution, ...
        constraints=selectedCase.pointConstraints);
end

figure(Position=[100 100 980 760])
tiledlayout(3, 1, TileSpacing="compact")

plotPanel(tq, t, x, defaultSpline, selectedFreeSpline, selectedConstrainedSpline, ...
    selectedCase, 0, "Position", "Constrained spline case exploration", "");
plotPanel(tq, t, x, defaultSpline, selectedFreeSpline, selectedConstrainedSpline, ...
    selectedCase, 1, "Velocity", "", "");
plotPanel(tq, t, x, defaultSpline, selectedFreeSpline, selectedConstrainedSpline, ...
    selectedCase, 2, "Acceleration", "", "Time");

annotation("textbox", [0.14 0.93 0.72 0.04], ...
    String=sprintf("Case %d: %s", exampleCase, selectedCase.summary), ...
    EdgeColor="none", HorizontalAlignment="center", FontWeight="bold");

function plotPanel(tq, t, x, defaultSpline, selectedFreeSpline, selectedConstrainedSpline, ...
        selectedCase, derivativeOrder, yLabelText, panelTitle, xLabelText)
nexttile
hold on

plot(tq, defaultSpline(tq, derivativeOrder), "--", LineWidth=1.75, ...
    DisplayName="Default fit")

if ~isempty(selectedFreeSpline)
    plot(tq, selectedFreeSpline(tq, derivativeOrder), "-.", LineWidth=1.75, ...
        DisplayName="Selected knots, unconstrained")
end

if ~isempty(selectedConstrainedSpline)
    plot(tq, selectedConstrainedSpline(tq, derivativeOrder), LineWidth=2.25, ...
        DisplayName="Selected knots with constraints")
end

if derivativeOrder == 0
    scatter(t, x, 45, "filled", DisplayName="Samples")
    ylim([-1, 11])
end

addKnotLines(selectedCase.tKnot)
markConstraintLocations(selectedCase.pointConstraints, derivativeOrder)
grid on
ylabel(yLabelText)

if ~isempty(panelTitle)
    title(panelTitle)
end

if derivativeOrder == 0
    legend(Location="southoutside")
else
    set(gca, XTickLabel=[])
end

if ~isempty(xLabelText)
    xlabel(xLabelText)
end
end

function addKnotLines(tKnot)
if isempty(tKnot)
    return
end

for knotValue = unique(tKnot(:)).'
    xline(knotValue, ":", Color=[0.2 0.6 0.2], LineWidth=1);
end
end

function markConstraintLocations(pointConstraints, derivativeOrder)
if isempty(pointConstraints)
    return
end

constraintPoints = [];
for iConstraint = 1:numel(pointConstraints)
    if all(pointConstraints(iConstraint).D == derivativeOrder, 2)
        constraintPoints = [constraintPoints; pointConstraints(iConstraint).Points]; %#ok<AGROW>
    end
end

if isempty(constraintPoints)
    return
end

yLimits = ylim();
markerY = yLimits(1) + 0.08*range(yLimits);
scatter(constraintPoints, markerY*ones(size(constraintPoints)), 35, "filled", ...
    MarkerFaceColor=[0.85 0.2 0.2], MarkerEdgeColor="none", ...
    DisplayName="Constraint location");
end

function specification = caseSpecification(exampleCase)
constraintTimes = [2.5; 2.5; 7.5];
constraintOrders = [1; 2; 2];
pointConstraints = PointConstraint.equal(constraintTimes, D=constraintOrders, Value=0);

switch exampleCase
    case 1
        specification = struct( ...
            "tKnot", [], ...
            "pointConstraints", [], ...
            "summary", "Default unconstrained fit with automatically chosen knots.");
    case 2
        specification = struct( ...
            "tKnot", [0; 4; 4.5; 5.5; 6; 10], ...
            "pointConstraints", pointConstraints, ...
            "summary", "Transition knots with local stationary and zero-acceleration constraints.");
    case 3
        specification = struct( ...
            "tKnot", [0; 3.5; 4.5; 5.5; 6.5; 10], ...
            "pointConstraints", pointConstraints, ...
            "summary", "Wider transition region with the same local constraints.");
    case 4
        specification = struct( ...
            "tKnot", [0; 5; 5; 10], ...
            "pointConstraints", pointConstraints, ...
            "summary", "Single repeated midpoint knot with the same local constraints.");
    case 5
        specification = struct( ...
            "tKnot", [0; 4; 4; 6; 6; 10], ...
            "pointConstraints", pointConstraints, ...
            "summary", "Repeated midpoint knots that allow sharper regime changes.");
    case 6
        specification = struct( ...
            "tKnot", [0; 4.5; 4.5; 5.5; 5.5; 10], ...
            "pointConstraints", pointConstraints, ...
            "summary", "Repeated transition knots centered on the observed jump.");
    otherwise
        error("ConstrainedSplineExample:UnknownCase", ...
            "exampleCase must be an integer from 1 to 6.");
end
end
