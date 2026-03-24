---
layout: default
title: domain
parent: BSpline
grand_parent: Classes
nav_order: 8
mathjax: true
---

#  domain

Minimum and maximum values of the spline domain.


---

## Discussion

  For a terminated spline basis, the domain is the interval covered
  by the repeated end knots:

  $$
  \mathrm{domain} = [\tau_1,\ \tau_{N_k}].
  $$

  Outside this interval the terminated basis is zero, so this
  property is the natural plotting and evaluation range for the
  spline.

  ```matlab
  spline.domain
  % returns [tMin tMax]
  ```


