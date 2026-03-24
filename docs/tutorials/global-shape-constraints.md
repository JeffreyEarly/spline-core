---
layout: default
title: Global Shape Constraints
parent: Tutorials
nav_order: 5
mathjax: true
permalink: /tutorials/global-shape-constraints
---

# Global Shape Constraints

Enforce positivity and monotonicity over an entire one-dimensional domain.

Source: `Examples/Tutorials/GlobalShapeConstraints.m`

## Enforce positivity and monotonicity across the whole domain

[`GlobalConstraint`](../classes/constraints/globalconstraint) objects do
not act at a few selected points. Instead they describe the shape of a
[`ConstrainedSpline`](../classes/constrainedspline) fit everywhere on
the domain:

$$
f(t)\ge 0,\qquad f'(t)\ge 0 \quad \text{for all } t.
$$

```matlab
rng(4)
t = linspace(0, 1, 45)';
xTrue = 0.15 + 0.85*(1 - exp(-4*t));
xObs = xTrue + 0.05*randn(size(t));
tq = linspace(t(1), t(end), 400)';

noiseModel = NormalDistribution(0.05);
freeFit = ConstrainedSpline(t, xObs, S=3, splineDOF=12, distribution=noiseModel);

shapeConstraints = [ ...
    GlobalConstraint.positive()
    GlobalConstraint.monotonicIncreasing()];

shapeFit = ConstrainedSpline(t, xObs, S=3, splineDOF=12, distribution=noiseModel, constraints=shapeConstraints);
```

Plot the unconstrained and globally constrained fits together.

```matlab
figure(Position=[100 100 820 320])
plot(tq, 0.15 + 0.85*(1 - exp(-4*tq)), "k--", LineWidth=1.5), hold on
plot(tq, freeFit(tq), LineWidth=2)
plot(tq, shapeFit(tq), LineWidth=2)
scatter(t, xObs, 28, "filled", MarkerFaceAlpha=0.65)
xlabel("t")
ylabel("x(t)")
legend("Underlying signal", "Unconstrained fit", "Positive monotone fit", "Observations", Location="southoutside")
grid on
```

![GlobalConstraint objects can enforce positivity and monotonic increase over the full domain in one fit.](./global-shape-constraints/positive-monotone-fit.png)

*GlobalConstraint objects can enforce positivity and monotonic increase over the full domain in one fit.*

## Check the constrained derivative

The first derivative is the clearest way to see the monotonicity
condition. Once the global monotone-increasing constraint is active, the
fitted derivative stays nonnegative throughout the interval.

```matlab
dFree = freeFit.valueAtPoints(tq, D=1);
dShape = shapeFit.valueAtPoints(tq, D=1);
```

Plot the first derivative to check the monotonicity condition directly.

```matlab
figure(Position=[100 100 780 300])
plot(tq, dFree, LineWidth=1.6), hold on
plot(tq, dShape, LineWidth=2)
yline(0, "k--")
xlabel("t")
ylabel("dx/dt")
legend("Unconstrained", "Positive monotone fit", Location="southoutside")
grid on
```

![The constrained fit keeps the first derivative nonnegative across the whole domain.](./global-shape-constraints/positive-monotone-derivative.png)

*The constrained fit keeps the first derivative nonnegative across the whole domain.*

