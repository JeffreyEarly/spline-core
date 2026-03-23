---
layout: default
title: subsref
parent: BSpline
grand_parent: Classes
nav_order: 21
mathjax: true
---

#  subsref

Evaluate the spline with function-call syntax or defer to built-in indexing.


---

## Declaration
```matlab
 varargout = subsref(self,index)
```
## Parameters
+ `self`  BSpline instance
+ `index`  MATLAB subscript structure

## Returns
+ `varargout`  indexed property access or spline values

## Discussion

  Parentheses indexing `spline(t)` is redirected to
  `valueAtPoints(...)`, while dot indexing behaves like the default
  MATLAB handle-class implementation.

  Use `spline(t)` for values. For derivatives, use
  `valueAtPoints(t, D=...)`.

  ```matlab
  x = spline(tQuery);
  dxdt = spline.valueAtPoints(tQuery, D=1);
  ```
