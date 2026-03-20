---
layout: default
title: Getting Started
nav_order: 3
description: Getting Started Guide
permalink: /getting-started
---

# Getting Started

This tutorial demonstrates the basic usage of the spline classes.

## Initialization

The `BSpline` class constructs and evaluates a spline basis once you specify
the order, terminated knot sequence, and spline coefficients.

```matlab
K = 4;
t = (0:10)';
tKnot = [repmat(t(1),K-1,1); t; repmat(t(end),K-1,1)];
xi = zeros(numel(tKnot)-K,1);
xi(4) = 1;

spline = BSpline(K,tKnot,xi);
```

You can now evaluate the spline and its derivatives using function-call
syntax,

```matlab
spline(5.5)
spline(5.5,1)
```

## Interpolating splines

For interpolation problems, `InterpolatingSpline` chooses an appropriate
terminated knot sequence from the sample locations and solves for the spline
coefficients directly.

```matlab
x = linspace(0,20,10)';
y = sin(2*pi*x/10);
f = InterpolatingSpline(x,y);
```

The interpolated spline can then be evaluated on a denser grid for plotting
or analysis,

```matlab
xDense = linspace(0,20,200)';
yDense = f(xDense);

figure
plot(xDense,yDense,"LineWidth",2), hold on
scatter(x,y,"filled")
legend("InterpolatingSpline","Samples")
```

![Interpolating spline example](./figures/interpolatingspline.png)

## Constrained fits

`ConstrainedSpline` extends `BSpline` to fit noisy data with local derivative
constraints and optional global shape constraints.

```matlab
t = linspace(0,1,50)';
x = exp(t) + 0.05*randn(size(t));
K = 4;
tKnot = BSpline.knotPointsForDataPoints(t,K=K,dataDOF=2);
constraints = struct("global",ShapeConstraint.monotonicIncreasing);

fit = ConstrainedSpline(t,x,K,tKnot,[],constraints);
```

The class documentation provides the full method-level reference for basis
construction, evaluation, constrained fitting, and shape constraints.

## Tensor-product splines

`TensorSpline` and `InterpolatingTensorSpline` extend the same ideas to
rectilinear grids in multiple dimensions.

```matlab
x = linspace(-1,1,6)';
y = linspace(0,2,7)';
[X,Y] = ndgrid(x,y);
F = X.^2 .* Y.^3 + 2*X.*Y - 5;

tensorSpline = InterpolatingTensorSpline({x,y}, F, K=[4 4]);
Fq = tensorSpline({X,Y});
```

The tensor classes support mixed partial derivatives as well, for example
`tensorSpline({X,Y}, [1 0])` for the derivative with respect to the first
dimension.
