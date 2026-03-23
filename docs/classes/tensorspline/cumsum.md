---
layout: default
title: cumsum
parent: TensorSpline
grand_parent: Classes
nav_order: 5
mathjax: true
---

#  cumsum

Return the indefinite integral along one tensor dimension.


---

## Declaration
```matlab
 intspline = cumsum(self,dim)
```
## Parameters
+ `self`  TensorSpline instance
+ `dim`  tensor dimension to integrate along

## Returns
+ `intspline`  TensorSpline representing the integral

## Discussion

  The integral is zero at the lower bound of the selected
  dimension while holding all other coordinates fixed.

  This applies the one-dimensional B-spline integration formula along the
  chosen tensor dimension and leaves the other dimensions unchanged.

  ```matlab
  F = cumsum(spline);
  Fy = cumsum(spline, 2);
  ```


