---
layout: default
title: knotPoints
parent: BSpline
grand_parent: Classes
nav_order: 13
mathjax: true
---

#  knotPoints

Knot sequence used to define the spline basis.


---

## Discussion

  This is the terminated knot vector

  $$
  \tau = [\tau_1,\ldots,\tau_{N_k}]^\mathsf{T}
  $$

  that defines the basis functions $$B_{j,S}(t;\tau)$$. Repeating the
  first and last knot values `K` times terminates the basis at the
  endpoints; interior multiplicity controls continuity across knot
  locations.

  For example, the cubic knot vector

  ```matlab
  knotPoints = [0; 0; 0; 0; 0.3; 0.7; 1; 1; 1; 1];
  ```

  defines four cubic basis functions on the domain `[0, 1]`. Use
  [`knotPointsForDataPoints`](/spline-core/classes/bspline/knotpointsfordatapoints.html)
  to build a terminated knot sequence from sample locations.


