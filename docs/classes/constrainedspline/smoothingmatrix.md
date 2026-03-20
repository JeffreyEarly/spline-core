---
layout: default
title: smoothingMatrix
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 12
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

  Use this to inspect how the fitted values depend linearly on
  the observed samples for the final weighted fit.
 
  ```matlab
  S = spline.smoothingMatrix();
  xFit = S * spline.x;
  ```
 
        
