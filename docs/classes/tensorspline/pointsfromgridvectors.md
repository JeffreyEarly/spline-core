---
layout: default
title: pointsFromGridVectors
parent: TensorSpline
grand_parent: Classes
nav_order: 13
mathjax: true
---

#  pointsFromGridVectors

Convert rectilinear grid vectors into an explicit point matrix.


---

## Declaration
```matlab
 [pointMatrix,gridSize] = pointsFromGridVectors(gridVectors)
```
## Parameters
+ `gridVectors`  cell array of grid vectors

## Returns
+ `pointMatrix`  matrix with one row per grid point
+ `gridSize`  number of points along each dimension

## Discussion

  Use this helper to convert rectilinear grid vectors into the
  point-matrix format accepted by `TensorSpline.matrix`.

  ```matlab
  [points, gridSize] = TensorSpline.pointsFromGridVectors({x,y});
  B = TensorSpline.matrix(points, tKnot, [4 4]);
  ```


