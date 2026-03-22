---
layout: default
title: SplineConstraint
parent: SplineConstraint
grand_parent: Classes
nav_order: 1
mathjax: true
---

#  SplineConstraint

Common superclass for local and global spline constraint objects.


---

## Declaration
```matlab
 classdef SplineConstraint < matlab.mixin.Heterogeneous
```
## Discussion

  Use `SplineConstraint` when you want to pass a mixed array of
  `PointConstraint` and `GlobalConstraint` objects through one API.
 
  ```matlab
  constraints = [
      PointConstraint.equal(0, D=1, Value=0)
      GlobalConstraint.positive()
  ];
  ```
 
    
