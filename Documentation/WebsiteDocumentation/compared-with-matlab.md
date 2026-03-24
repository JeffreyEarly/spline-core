---
layout: default
title: Compared with MATLAB
nav_order: 7
description: "Where spline-core aligns with MATLAB built-ins and where it goes beyond"
permalink: /compared-with-matlab
---

# Compared with MATLAB

`Spline Core` is designed to feel familiar if you already use MATLAB's
built-in interpolation and fitting functions. The main difference is that
the package keeps those workflows inside a consistent spline-object model
that also supports low-level basis access, robust fitting, and constraints.

## At a glance

| Familiar MATLAB tool | `Spline Core` alignment | What `Spline Core` adds |
| --- | --- | --- |
| `interp1` | `InterpolatingSpline(t, x, S=3)` | reusable spline objects, derivatives, roots, and knot access |
| `griddedInterpolant` | `InterpolatingSpline({x, y}, V, S=[3 3])` | tensor derivatives, basis access, and the same family as constrained fitting |
| `polyfit` | `ConstrainedSpline(t, x, S=N-1, splineDOF=N)` | richer spline spaces, robust fitting, and constraints |

## `interp1` and one-dimensional interpolation

If your mental model is `interp1`, the alignment is straightforward:

```matlab
% MATLAB built-in
vq = interp1(t, x, tq, "spline");

% spline-core
f = InterpolatingSpline(t, x, S=3);
vq = f(tq);
```

Where `Spline Core` goes beyond `interp1`:

- the result is a spline object, not just returned values
- derivatives use the same object: `f.valueAtPoints(tq, D=1)`
- roots, transforms, coefficients, and knot vectors remain available
- irregularly spaced data are a natural input

## `griddedInterpolant` and rectilinear grids

For multidimensional interpolation on a rectilinear grid, the package is
intentionally close to MATLAB's `griddedInterpolant` style:

```matlab
% MATLAB built-in
F = griddedInterpolant({x, y}, V, "spline");
Vq = F({xq, yq});

% spline-core
F = InterpolatingSpline({x, y}, V, S=[3 3]);
Vq = F(Xq, Yq);
```

Where `Spline Core` goes beyond `griddedInterpolant`:

- mixed partial derivatives use the same object: `F.valueAtPoints(Xq, Yq, D=[1 0])`
- the same spline family also supports noisy fitting through `ConstrainedSpline`
- you can drop to the low-level tensor basis through `TensorSpline.matrixForPointMatrix`

## `polyfit` and least-squares polynomial fits

In one dimension, `ConstrainedSpline` can reproduce the least-squares
polynomial role of `polyfit`:

```matlab
% MATLAB built-in
p = polyfit(t, x, 3);
xFit = polyval(p, tq);

% spline-core
fit = ConstrainedSpline(t, x, S=3, splineDOF=4);
xFit = fit(tq);
```

The direct alignment is:

- `polyfit(t, x, N-1)` corresponds to `ConstrainedSpline(t, x, S=N-1, splineDOF=N)`

Where `Spline Core` goes beyond `polyfit`:

- move from a minimal polynomial basis to richer spline spaces by increasing `splineDOF`
- keep irregularly spaced data as a natural input
- add robust error models or constraints without leaving the same interface

## What MATLAB does not bundle directly

Robust fitting and constraints are the clearest places where `Spline Core`
goes beyond MATLAB's standard interpolation tools.

```matlab
fit = ConstrainedSpline(t, xObs, S=3, splineDOF=12, ...
    distribution=StudentTDistribution(sigma=0.1, nu=3), ...
    constraints=[
        PointConstraint.equal(0, D=1, value=0)
        GlobalConstraint.monotonicIncreasing()
    ]);
```

That single object can combine:

- spline fitting
- robust error models
- local value or derivative constraints
- global positivity or monotonicity constraints

## Where to go next

- [Spline Interpolation](tutorials/interpolation-on-grids)
- [Fitting Noisy Data](tutorials/fitting-noisy-data)
- [Robust Fitting with Outliers](tutorials/robust-fitting-with-outliers)
- [Class Documentation](classes)
