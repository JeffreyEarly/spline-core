---
layout: default
title: subsref
parent: TensorSpline
grand_parent: Classes
nav_order: 18
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

  Use `spline(X)` for values and `spline(X,D)` for mixed
  partial derivatives.

  ```matlab
  values = spline(queryPoints);
  values = spline(xq, yq);
  dFdx = spline(xq, yq, [1 0]);
  ```


