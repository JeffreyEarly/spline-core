---
layout: default
title: ShapeConstraint
parent: ShapeConstraint
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  ShapeConstraint

Enumerate supported global shape constraints for constrained splines.


---

## Declaration
```matlab
 classdef ShapeConstraint
```
## Discussion

  These values are interpreted by ConstrainedSpline when constructing
  global inequality constraints on spline coefficients.
 
  ## Basic usage
 
  Use these enumeration values when selecting a global shape
  constraint for `ConstrainedSpline`.
 
  ```matlab
  constraints.global = ShapeConstraint.monotonicIncreasing;
  spline = ConstrainedSpline(t, x, 4, tKnot, [], constraints);
  ```
 
    
