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
  Use `spline(X1,...,Xn)` for values. For derivatives, use
  `valueAtPoints(X1,...,Xn,D=...)`.

  ```matlab
  values = spline(xq, yq);
  dFdx = spline.valueAtPoints(xq, yq, D=[1 0]);
  ```
