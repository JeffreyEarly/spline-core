---
layout: default
title: numDimensions
parent: TensorSpline
grand_parent: Classes
nav_order: 14
mathjax: true
---

#  numDimensions

Number of tensor dimensions.


---

## Discussion

  This is the number of coordinate directions in the tensor-product
  spline. In one dimension it is `1`; in higher dimensions it equals
  the number of knot vectors in
  [`knotPoints`](/spline-core/classes/tensorspline/knotpoints.html).

  ```matlab
  spline.numDimensions
  % returns 2 for a surface spline, 3 for a volume spline
  ```


