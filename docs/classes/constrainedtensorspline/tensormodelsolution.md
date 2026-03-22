---
layout: default
title: tensorModelSolution
parent: ConstrainedTensorSpline
grand_parent: Classes
nav_order: 16
mathjax: true
---

#  tensorModelSolution

Solve the tensor noisy-data model with iteratively reweighted least squares.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 [xi,CmInv,W] = tensorModelSolution(values,designMatrix,distribution,rho_X,Aeq,beq,Aineq,bineq)
```
## Parameters
+ `values`  observation values as an N-by-1 vector
+ `designMatrix`  splines on the observation grid, N-by-M
+ `distribution`  distribution describing the errors
+ `rho_X`  optional observation correlation matrix
+ `Aeq`  optional equality-constraint matrix
+ `beq`  optional equality-constraint values
+ `Aineq`  optional inequality-constraint matrix
+ `bineq`  optional inequality-constraint values

## Returns
+ `xi`  fitted tensor spline coefficients
+ `CmInv`  inverse coefficient covariance or system matrix
+ `W`  final weight matrix or weights

## Discussion

                            
