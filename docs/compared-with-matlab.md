---
layout: default
title: Compared with MATLAB
nav_order: 7
description: "Where spline-core aligns with MATLAB built-ins and where it goes beyond"
permalink: /compared-with-matlab
---

# Compared with MATLAB

`Spline Core` is meant to feel familiar if you already use MATLAB's built-in
interpolation and fitting functions. The main difference is that the
package keeps those familiar workflows inside a consistent spline-object
model that also supports low-level basis access, robust fitting, and
constraints.

## At a glance

| Familiar MATLAB tool | `Spline Core` alignment | What `Spline Core` adds |
| --- | --- | --- |
| `interp1` | `InterpolatingSpline(t, x, K=4)` | inspectable spline objects, derivatives, roots, knot access |
| `griddedInterpolant` | `InterpolatingSpline({x, y}, V, K=[4 4])` | tensor derivatives, basis access, same family as constrained fitting |
| `polyfit` | `ConstrainedSpline(t, x, K=N, splineDOF=N)` | data-driven spline spaces, robust fitting, local/global constraints |

The rest of this page gives the side-by-side code and the main differences
for each case.

## `interp1` and one-dimensional interpolation

If your mental model is `interp1`, the alignment is straightforward:

```matlab
% MATLAB built-in
vq = interp1(t, x, tq, "spline");

% spline-core
f = InterpolatingSpline(t, x, K=4);
vq = f(tq);
```

Where `Spline Core` goes beyond `interp1`:

- the result is a spline object, not just returned values
- derivatives use the same function-call syntax: `f(tq, 1)`
- roots, integrals, transforms, coefficients, and knot vectors remain available
- irregularly spaced data are a natural input, and in 1D the canonical knot
  sequence is chosen from the data locations themselves

## `griddedInterpolant` and rectilinear tensor grids

For multidimensional interpolation on a rectilinear grid, the package is
intentionally close to MATLAB's `griddedInterpolant` style:

```matlab
% MATLAB built-in
F = griddedInterpolant({x, y}, V);
Vq = F(Xq, Yq);

% spline-core
F = InterpolatingSpline({x, y}, V, K=[4 4]);
Vq = F(Xq, Yq);
```

Where `Spline Core` goes beyond `griddedInterpolant`:

- the same spline family also supports noisy fitting through `ConstrainedSpline`
- mixed partial derivatives use the same object: `F(Xq, Yq, [1 0])`
- you can drop to the low-level tensor basis through `TensorSpline.matrix`
- the interpolation object still participates in the same coefficient/knot-based spline workflow as the rest of the package

One modeling boundary is important here: `InterpolatingSpline` in multiple
dimensions is rectilinear-grid interpolation, not arbitrary scattered-data
interpolation.

## `polyfit` and least-squares polynomial fitting

In one dimension, `ConstrainedSpline` can reproduce the least-squares
polynomial role of `polyfit`:

```matlab
% MATLAB built-in
p = polyfit(t, x, 3);
xFit = polyval(p, tq);

% spline-core
fit = ConstrainedSpline(t, x, K=4, splineDOF=4);
xFit = fit(tq);
```

The alignment is:

- `polyfit(t, x, N-1)` corresponds to `ConstrainedSpline(t, x, K=N, splineDOF=N)`

Where `Spline Core` goes beyond `polyfit`:

- you can move from the minimal polynomial basis to richer spline spaces by increasing `splineDOF`
- knot placement is data-driven rather than tied to a single global polynomial basis
- irregularly spaced data remain natural
- robust fitting is built in through alternate error models
- local and global constraints fit into the same interface

## Robust fitting and constraints

This is the clearest place where the package goes beyond MATLAB's standard
interpolation functions.

```matlab
fit = ConstrainedSpline(t, x, ...
    K=4, ...
    dataDOF=2, ...
    distribution=StudentTDistribution(sigma=0.1, nu=3), ...
    constraints=[
        PointConstraint.equal(0, D=1, value=0)
        GlobalConstraint.monotonicIncreasing()
    ]);
```

That single object can combine:

- data-driven spline basis selection
- robust fitting
- local value or derivative constraints
- global positivity or monotonicity constraints

This is the main capability gap between `Spline Core` and the basic
built-in interpolation functions.

## Interpolation and fitting stay in one family

Another practical advantage is that interpolation and fitting are not
separate conceptual worlds here.

- `InterpolatingSpline` is the exact-data side of the family
- `ConstrainedSpline` is the noisy/constrained side of the same family
- `BSpline` and `TensorSpline` expose the lower-level objects underneath

That makes it easy to start with an exact interpolation workflow and move
toward constrained or robust fitting without leaving the spline framework.
