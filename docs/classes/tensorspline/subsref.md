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

  Use `spline(X1,...,Xn)` for values and
  `spline(X1,...,Xn,D)` for mixed partial derivatives.

  ```matlab
  values = spline(xq, yq);
  dFdx = spline(xq, yq, [1 0]);
  ```


