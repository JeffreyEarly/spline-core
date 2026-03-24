---
layout: default
title: compileGlobalConstraints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 2
mathjax: true
---

#  compileGlobalConstraints

Compile global constraints into coefficient inequalities.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 [Aineq,bineq] = compileGlobalConstraints(globalConstraints,tKnot,K)
```
## Parameters
+ `globalConstraints`  GlobalConstraint array
+ `tKnot`  per-dimension knot vectors
+ `K`  spline order per dimension

## Returns
+ `Aineq`  inequality-constraint matrix
+ `bineq`  inequality-constraint right-hand side

## Discussion

  This helper turns global shape requests into coefficient-space
  inequalities of the form

  $$
  A_{\mathrm{ineq}}\xi \le 0.
  $$

  Positivity uses $$\xi_j \ge 0$$, which is sufficient because the terminated
  B-spline basis is nonnegative. Monotonicity uses first differences of
  adjacent coefficients along a selected tensor dimension, via
  [`monotonicDifferenceMatrix`](/spline-core/classes/constrainedspline/monotonicdifferencematrix.html).


