---
layout: default
title: pointsOfSupportFromKnotPoints
parent: BSpline
grand_parent: Classes
nav_order: 18
mathjax: true
---

#  pointsOfSupportFromKnotPoints

Return representative support points for a terminated spline basis.


---

## Declaration
```matlab
 t = pointsOfSupportFromKnotPoints(knotPoints, options)
```
## Parameters
+ `knotPoints`  knot sequence
+ `options.S`  spline degree

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
  tSupport = BSpline.pointsOfSupportFromKnotPoints(knotPoints, S=3);
  xSupport = spline(tSupport);
  ```


