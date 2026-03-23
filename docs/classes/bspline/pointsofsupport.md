---
layout: default
title: pointsOfSupport
parent: BSpline
grand_parent: Classes
nav_order: 16
mathjax: true
---

#  pointsOfSupport

Return representative support points for a terminated spline basis.


---

## Declaration
```matlab
 t = pointsOfSupport(knotPoints, S)
```
## Parameters
+ `knotPoints`  knot sequence
+ `S`  spline degree

## Returns
+ `t`  support point locations

## Discussion

  This function assumes that the splines are terminated at the boundary
  with repeated end knots. It returns one representative point per basis
  function, using knot midpoints or interior knot values depending on the
  spline order parity.

  These points are especially useful when a nonlinear transform is
  approximated by sampling a spline and refitting another spline to the
  sampled values.

  ```matlab
  tSupport = BSpline.pointsOfSupport(knotPoints, 3);
  xSupport = spline(tSupport);
  ```


