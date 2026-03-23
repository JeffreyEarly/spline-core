---
layout: default
title: evaluatePoints
parent: TensorSpline
grand_parent: Classes
nav_order: 8
mathjax: true
---

#  evaluatePoints

Evaluate the tensor spline at explicit point locations.


---

## Declaration
```matlab
 values = evaluatePoints(self,points,options)
```
## Parameters
+ `self`  TensorSpline instance
+ `points`  query points as a vector in 1-D or an N-by-D matrix in higher dimensions
+ `options.D`  derivative order per dimension

## Returns
+ `values`  one value per query point, preserving input shape in 1-D

## Discussion

  Use this for scattered query points represented as one point
  per row.

  ```matlab
  values = spline.evaluatePoints([xq(:), yq(:)]);
  ```


