---
layout: default
title: subsref
parent: TensorSpline
grand_parent: Classes
nav_order: 19
mathjax: true
---

#  subsref

Evaluate the tensor spline with function-call syntax or defer to built-in indexing.


---

## Declaration
```matlab
 varargout = subsref(self,index)
```
## Parameters
+ `self`  TensorSpline instance
+ `index`  MATLAB subscript structure

## Returns
+ `varargout`  indexed property access or spline values

## Discussion

  Function-call syntax is a thin wrapper around `valueAtPoints(...)`.
  Use `spline(X1,...,Xn)` for pointwise values at matching-size
  query arrays. Paired column vectors evaluate paired sample locations,
  while matching `ndgrid` arrays evaluate a tensor-product lattice. For
  derivatives, use `valueAtPoints(X1,...,Xn,D=...)`.

  ```matlab
  values = spline(xq, yq);
  [Xq,Yq] = ndgrid(linspace(-1,1,40), linspace(0,2,50));
  F = spline(Xq, Yq);
  dFdx = spline.valueAtPoints(xq, yq, D=[1 0]);
  ```


