---
layout: default
title: Common Tasks
nav_order: 4
description: "Practical entry points for common spline workflows"
permalink: /common-tasks
---

# Common Tasks

Use this page when you know what you want to do, but want the right class,
tutorial, or code pattern quickly. If you are still choosing between the
main classes, start with [Which Class Should I Use?](which-class-should-i-use).

## Interpolate exact data in one dimension

- Use [`InterpolatingSpline`](classes/interpolatingspline)
- Start with [Spline Interpolation](tutorials/interpolation-on-grids)

```matlab
t = linspace(0, 1, 20)';
x = sin(2*pi*t);
f = InterpolatingSpline.fromGriddedValues(t, x, S=3);
xq = f(linspace(t(1), t(end), 200)');
```

## Interpolate exact data on a rectilinear grid

- Use [`InterpolatingSpline`](classes/interpolatingspline)
- Pass one grid vector per dimension

```matlab
F = InterpolatingSpline.fromGriddedValues({x, y}, V, S=[3 3]);
Vq = F(Xq, Yq);
```

## Fit noisy data

- Use [`ConstrainedSpline`](classes/constrainedspline)
- Start with [Fitting Noisy Data](tutorials/fitting-noisy-data)

```matlab
noiseModel = NormalDistribution(0.05);
fit = ConstrainedSpline.fromGriddedValues(t, xObs, S=3, splineDOF=12, distribution=noiseModel);
```

To match the least-squares polynomial fit from `polyfit(t, x, N-1)`, use
`S=N-1` and `splineDOF=N`.

## Fit noisy data with outliers

- Use [`ConstrainedSpline`](classes/constrainedspline) with `StudentTDistribution`
- Start with [Robust Fitting with Outliers](tutorials/robust-fitting-with-outliers)

```matlab
fit = ConstrainedSpline.fromGriddedValues(t, xObs, S=3, splineDOF=12, ...
    distribution=StudentTDistribution(sigma=0.05, nu=3));
```

## Add local value or derivative constraints

- Use [`PointConstraint`](classes/constraints/pointconstraint)
- Start with [Local Point Constraints](tutorials/local-point-constraints)

```matlab
constraints = [
    PointConstraint.equal(0.5, value=1)
    PointConstraint.equal(0.5, D=1, value=0)
];

fit = ConstrainedSpline.fromGriddedValues(t, xObs, S=3, splineDOF=12, constraints=constraints);
```

## Add global positivity or monotonicity constraints

- Use [`GlobalConstraint`](classes/constraints/globalconstraint)
- Start with [Global Shape Constraints](tutorials/global-shape-constraints)

```matlab
fit = ConstrainedSpline.fromGriddedValues(t, xObs, S=3, splineDOF=12, ...
    constraints=GlobalConstraint.monotonicIncreasing());
```

## Add a 2D constraint on a rectilinear grid

- Use [`ConstrainedSpline`](classes/constrainedspline) with [`GlobalConstraint.monotonicIncreasing`](classes/constraints/globalconstraint/monotonicincreasing)
- Start with [2D Constraints](tutorials/rectilinear-grid-constraints-2d)

```matlab
fit = ConstrainedSpline.fromGriddedValues({x, y}, VObs, S=[3 3], splineDOF=[10 10], ...
    constraints=GlobalConstraint.monotonicIncreasing(dimension=2));
```

## Fit a planar trajectory from shared-parameter samples

- Use [`TrajectorySpline`](classes/trajectoryspline)
- Start with the [`TrajectorySpline`](classes/trajectoryspline) class reference

```matlab
trajectory = TrajectorySpline.fromData(t, x, y, S=3);
tq = linspace(t(1), t(end), 200)';

xq = trajectory.x(tq);
yq = trajectory.y(tq);
uq = trajectory.u(tq);
vq = trajectory.v(tq);
```

For persisted restart or prefit component splines, construct the canonical
state directly with `TrajectorySpline(t=t, x=xSpline, y=ySpline)`.

## Work directly with basis matrices

- Use [`BSpline.matrixForDataPoints`](classes/bspline/matrixfordatapoints) or [`TensorSpline.matrixForPointMatrix`](classes/tensorspline/matrixforpointmatrix)
- Start with [BSpline Foundations](tutorials/bspline-foundations) or [TensorSpline Foundations](tutorials/tensorspline-foundations)

```matlab
knotPoints = BSpline.knotPointsForDataPoints(t, S=3);
B = BSpline.matrixForDataPoints(t, knotPoints=knotPoints, S=3);
xi = B \ x;
```
