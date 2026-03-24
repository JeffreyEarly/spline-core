---
layout: default
title: constrainedWeightedSolution
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 4
mathjax: true
---

#  constrainedWeightedSolution

Solve weighted least squares with optional linear constraints.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 [xi,systemMatrix] = constrainedWeightedSolution(normalMatrix,rhs,Aeq,beq,Aineq,bineq)
```
## Parameters
+ `normalMatrix`  weighted normal-equation matrix
+ `rhs`  weighted right-hand side
+ `Aeq`  equality-constraint matrix
+ `beq`  equality-constraint right-hand side
+ `Aineq`  inequality-constraint matrix
+ `bineq`  inequality-constraint right-hand side

## Returns
+ `xi`  fitted coefficient vector
+ `systemMatrix`  solved system matrix or quadratic Hessian proxy

## Discussion

  If only equality constraints are present, this forms and solves the KKT
  system

  $$
  \begin{bmatrix}
  N & A_{\mathrm{eq}}^T \\
  A_{\mathrm{eq}} & 0
  \end{bmatrix}
  \begin{bmatrix}
  \xi \\ \lambda
  \end{bmatrix}
  =
  \begin{bmatrix}
  r \\ b_{\mathrm{eq}}
  \end{bmatrix}.
  $$

  If inequality constraints are also present, the method switches to
  `quadprog` and solves the equivalent convex quadratic program with
  Hessian `N`.


