---
layout: default
title: domain
parent: TensorSpline
grand_parent: Classes
nav_order: 7
mathjax: true
---

#  domain

Minimum and maximum values of the spline domain in each dimension.


---

## Discussion

  `domain(k,:)` gives the lower and upper coordinate limits for
  tensor dimension `k`:

  $$
  \mathrm{domain}(k,:) = [\tau_{k,1},\ \tau_{k,\mathrm{end}}].
  $$

  So a 2-D spline returns a `2 x 2` array of `[min max]` pairs, one
  row for each coordinate direction.


