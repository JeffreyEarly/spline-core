---
layout: default
title: compilePointConstraints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 3
mathjax: true
---

#  compilePointConstraints

Compile point constraints into equality and inequality systems.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 [Aeq,beq,Aineq,bineq] = compilePointConstraints(pointConstraints,tKnot,K)
```
## Parameters
+ `pointConstraints`  PointConstraint array
+ `tKnot`  per-dimension knot vectors
+ `K`  spline order per dimension

## Returns
+ `Aeq`  equality-constraint matrix
+ `beq`  equality-constraint right-hand side
+ `Aineq`  inequality-constraint matrix
+ `bineq`  inequality-constraint right-hand side

## Discussion

  For each point constraint, this function evaluates the tensor-product
  basis or derivative row at the constrained points and turns the requested
  relation into linear constraints on the coefficient vector `xi`.

  If a row of the evaluated basis is denoted by $$b_m^T$$, then the three
  supported relations are compiled as

  $$
  b_m^{T}\xi = v_m, \qquad
  b_m^{T}\xi \le v_m, \qquad
  b_m^{T}\xi \ge v_m,
  $$

  with lower bounds rewritten as $$-b_m^T \xi \le -v_m$$.

  Rows sharing the same derivative order are batched together so the basis
  matrix only has to be evaluated once per derivative multi-index.


