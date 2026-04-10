---
layout: default
title: ConstrainedSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 4
---

#  ConstrainedSpline

Tensor-product spline fit through noisy data values.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef ConstrainedSpline < TensorSpline</code></pre></div></div>

## Overview

`ConstrainedSpline` is the noisy-data fitting counterpart to
`InterpolatingSpline`. It fits a tensor-product spline basis to
observations sampled on a one-dimensional grid or a rectilinear tensor
grid, with optional robust weighting, correlated observation errors,
local point constraints, and global shape constraints.

At each iteratively reweighted least-squares step it solves

$$
\min_{\xi}\ (y - \mathbf{B}\xi)^{T} W (y - \mathbf{B}\xi)
$$

subject to

$$
A_{\mathrm{eq}}\xi = b_{\mathrm{eq}}, \qquad
A_{\mathrm{ineq}}\xi \le b_{\mathrm{ineq}}.
$$

When the distribution model provides correlated errors, the code
forms an observation covariance

$$
\Sigma_{ij} = \sigma_i \rho(x_i,x_j)\sigma_j
$$

and applies the corresponding weighted solve through a matrix
factorization rather than explicitly forming $$\Sigma^{-1}$$.

## Basic usage

Use `ConstrainedSpline.fromData(...)` for ordinary one-dimensional
noisy-data fitting and `ConstrainedSpline.fromGriddedValues(...)`
when the observations lie on a rectilinear tensor grid.

```matlab
t = linspace(0,1,20)';
x = exp(-20*(t-0.5).^2) + 0.05*randn(size(t));
spline = ConstrainedSpline.fromData(t, x, S=3, constraints=GlobalConstraint.positive());
xFit = spline(t);
```




## Topics
+ Create a constrained tensor spline
  + [`ConstrainedSpline`](/spline-core/classes/constrainedspline/constrainedspline.html) Create a constrained spline from canonical solved state.
  + [`fromData`](/spline-core/classes/constrainedspline/fromdata.html) Create a constrained spline fit from one-dimensional samples.
  + [`fromGriddedValues`](/spline-core/classes/constrainedspline/fromgriddedvalues.html) Create a constrained spline fit from values on a rectilinear grid.
+ Inspect fit results
  + [`dataPoints`](/spline-core/classes/constrainedspline/datapoints.html) Observation locations as an N-by-D point matrix.
  + [`dataValues`](/spline-core/classes/constrainedspline/datavalues.html) Observation values as an N-by-1 vector.
  + [`distribution`](/spline-core/classes/constrainedspline/distribution.html) Error model used while fitting the tensor spline.
  + [`globalConstraints`](/spline-core/classes/constrainedspline/globalconstraints.html) Global shape constraints used during fitting.
  + [`gridAxes`](/spline-core/classes/constrainedspline/gridaxes.html) Grid-axis objects used to define the fitted rectilinear lattice.
  + [`gridVectors`](/spline-core/classes/constrainedspline/gridvectors.html) Grid vectors used to define the fitted rectilinear lattice.
  + [`pointConstraints`](/spline-core/classes/constrainedspline/pointconstraints.html) Local point constraints used during fitting.
+ Analyze the fit
  + [`smoothingMatrix`](/spline-core/classes/constrainedspline/smoothingmatrix.html) Return the smoothing matrix that maps observations to fitted values.
+ Choose constraint locations
  + [`minimumConstraintPoints`](/spline-core/classes/constrainedspline/minimumconstraintpoints.html) Return a minimal set of one-dimensional locations for universal derivative constraints.
+ Prepare knot sequences
  + [`terminatedKnotPoints`](/spline-core/classes/constrainedspline/terminatedknotpoints.html) Ensure each knot vector has S+1 repeated knots at its boundaries.


## Developer Topics
These items document internal implementation details and are not part of the primary public API.
+ Prepare fit inputs
  + [`normalizeConstraintInputs`](/spline-core/classes/constrainedspline/normalizeconstraintinputs.html) Split typed constraint inputs into point and global arrays.
+ Compile constraints
  + [`compileGlobalConstraints`](/spline-core/classes/constrainedspline/compileglobalconstraints.html) Compile global constraints into coefficient inequalities.
  + [`compilePointConstraints`](/spline-core/classes/constrainedspline/compilepointconstraints.html) Compile point constraints into equality and inequality systems.
  + [`monotonicDifferenceMatrix`](/spline-core/classes/constrainedspline/monotonicdifferencematrix.html) Build coefficient-difference inequalities along one dimension.
+ Solve fit systems
  + [`constrainedWeightedSolution`](/spline-core/classes/constrainedspline/constrainedweightedsolution.html) Solve weighted least squares with optional linear constraints.
  + [`leftSolve`](/spline-core/classes/constrainedspline/leftsolve.html) Solve a linear system, falling back to a pseudoinverse if needed.
  + [`tensorModelSolution`](/spline-core/classes/constrainedspline/tensormodelsolution.html) Solve the tensor noisy-data model with iteratively reweighted least squares.
  + [`weightMatrixFromSigma2`](/spline-core/classes/constrainedspline/weightmatrixfromsigma2.html) Build the observation-weight matrix from per-observation variances.
  + [`weightedNormalEquations`](/spline-core/classes/constrainedspline/weightednormalequations.html) Assemble weighted normal equations.


---