---
layout: default
title: smoothingMatrix
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 15
mathjax: true
---

#  smoothingMatrix

Return the smoothing matrix that maps observations to fitted values.


---

## Declaration
```matlab
 S = smoothingMatrix(self)
```
## Parameters
+ `self`  ConstrainedSpline instance

## Returns
+ `S`  smoothing matrix

## Discussion

  Use this to inspect the linear action of the final weighted
  fit on the observed data.

  ```matlab
  S = spline.smoothingMatrix();
  valuesFit = S * spline.values;
  ```


