---
layout: default
title: Getting Started
nav_order: 3
description: Getting Started Guide
permalink: /getting-started
---

# Getting Started

Use this page for the shortest path from installation to a first working
spline. If you already know the workflow you want, jump to
[Common Tasks](common-tasks). If you want a guided walkthrough, go to
[Tutorials](tutorials).

## 1. Install the package

`Spline Core` requires MATLAB R2024b or newer. Fitting workflows also
depend on the `Distributions` package.

```matlab
mpminstall("local/path/to/spline-core");
```

If you manage dependencies yourself, install without them explicitly:

```matlab
mpminstall("local/path/to/spline-core", InstallDependencies=false);
```

For full install details, see [Installation](installation).

## 2. Choose the right starting point

| If your data are... | Start with | Next page |
| --- | --- | --- |
| exact and trusted | [`InterpolatingSpline`](classes/interpolatingspline) | [Spline Interpolation](tutorials/interpolation-on-grids) |
| noisy or constrained | [`ConstrainedSpline`](classes/constrainedspline) | [Fitting Noisy Data](tutorials/fitting-noisy-data) |

If you only remember one distinction, use `InterpolatingSpline` for exact
interpolation and `ConstrainedSpline` for fitting.

## 3. Exact interpolation quickstart

```matlab
t = linspace(0, 1, 12)';
x = sin(2*pi*t);
f = InterpolatingSpline(t, x, S=3);

tq = linspace(t(1), t(end), 200)';
xq = f(tq);
dxq = f.valueAtPoints(tq, D=1);
```

This gives you a reusable spline object for values and derivatives. For
rectilinear grids, pass one grid vector per dimension:

```matlab
F = InterpolatingSpline({x, y}, V, S=[3 3]);
Vq = F(Xq, Yq);
```

## 4. Noisy fitting quickstart

```matlab
t = linspace(0, 1, 50)';
xObs = exp(t) + 0.05*randn(size(t));

noiseModel = NormalDistribution(0.05);
fit = ConstrainedSpline(t, xObs, S=3, splineDOF=12, distribution=noiseModel);

tq = linspace(t(1), t(end), 200)';
xFit = fit(tq);
```

From the same starting point you can add robust error models, local point
constraints, and global shape constraints.

## Where to go next

- [Spline Interpolation](tutorials/interpolation-on-grids)
- [Fitting Noisy Data](tutorials/fitting-noisy-data)
- [Robust Fitting with Outliers](tutorials/robust-fitting-with-outliers)
- [Which Class Should I Use?](which-class-should-i-use)
- [Common Tasks](common-tasks)
- [BSpline Foundations](tutorials/bspline-foundations)
- [TensorSpline Foundations](tutorials/tensorspline-foundations)
- [Class Documentation](classes)
