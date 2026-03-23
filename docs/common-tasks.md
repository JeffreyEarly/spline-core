---
layout: default
title: Common Tasks
nav_order: 4
description: "Practical entry points for common spline workflows"
permalink: /common-tasks
---

# Common Tasks

Use this page when you know what you want to do, but do not yet know which
class or tutorial to open. If you are still deciding between the main
classes, start with [Which Class Should I Use?](which-class-should-i-use).

## Interpolate exact data in one dimension

- Use [`InterpolatingSpline`](classes/interpolatingspline)
- Start with the [Interpolating Spline Basics](tutorials/interpolating-spline-basics) tutorial

```matlab
t = linspace(0, 1, 20)';
x = sin(2*pi*t);
f = InterpolatingSpline(t, x, K=4);
```

## Interpolate exact data on a rectilinear grid

- Use [`InterpolatingSpline`](classes/interpolatingspline)
- Pass a cell array of grid vectors plus the value array

```matlab
f = InterpolatingSpline({x, y}, F, K=[4 4]);
Fq = f(Xq, Yq);
```

## Fit noisy one-dimensional data

- Use [`ConstrainedSpline`](classes/constrainedspline)
- Start with the [Robust Fitting of Noisy Data](tutorials/robust-spline-fitting) tutorial

```matlab
fit = ConstrainedSpline(t, x, K=4, dataDOF=2);
```

To match the least-squares polynomial fit from `polyfit(t,x,N-1)`, use
`K=N` and `splineDOF=N`.

## Add local value or derivative constraints

- Use [`PointConstraint`](classes/constraints/pointconstraint)
- See [Local Point Constraints in 1D](tutorials/local-point-constraints-1d)

```matlab
constraints = [
    PointConstraint.equal(0, D=0, value=1)
    PointConstraint.equal(0, D=1, value=0)
];

fit = ConstrainedSpline(t, x, constraints=constraints);
```

## Add global positivity or monotonicity constraints

- Use [`GlobalConstraint`](classes/constraints/globalconstraint)
- See [Global Shape Constraints](tutorials/global-shape-constraints)

```matlab
fit = ConstrainedSpline(t, x, ...
    constraints=GlobalConstraint.monotonicIncreasing());
```

## Constrain a masked region on a tensor grid

- Use [`PointConstraint.equalOnMask`](classes/constraints/pointconstraint/equalonmask)
- See [Mask-Constrained Tensor Fits](tutorials/mask-constrained-fit)

```matlab
constraint = PointConstraint.equalOnMask({x, y}, islandMask, D=[0 0], value=0);
fit = ConstrainedSpline({x, y}, values, constraints=constraint);
```

## Fit scattered observations in two dimensions

- Use [`ConstrainedSpline`](classes/constrainedspline)
- See [Scattered Data Fitting in 2D](tutorials/scattered-data-fitting-2d)

```matlab
fit = ConstrainedSpline.fromPoints(P, zObs, K=[4 4]);
Zq = fit(Xq, Yq);
```

## Work directly with basis matrices

- Use [`BSpline.matrix`](classes/bspline/matrix) or [`TensorSpline.matrix`](classes/tensorspline/matrix)
- This is the right entry point for custom regression or inverse problems

```matlab
B = BSpline.matrix(t, tKnot, K);
xi = B \ x;
```
