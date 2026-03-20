---
layout: default
title: tensorModelSolution
parent: ConstrainedTensorSpline
grand_parent: Classes
nav_order: 8
mathjax: true
---

#  tensorModelSolution

Solve the tensor noisy-data model with iteratively reweighted least squares.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 [xi,CmInv,W] = tensorModelSolution(x,X,distribution,rho_X)
```
## Parameters
+ `x`  observation values as an N-by-1 vector
+ `X`  splines on the observation grid, N-by-M
+ `distribution`  distribution describing the errors
+ `rho_X`  optional observation correlation matrix

## Returns
+ `xi`  fitted tensor spline coefficients
+ `CmInv`  inverse coefficient covariance or system matrix
+ `W`  final weight matrix or weights

## Discussion

                    
