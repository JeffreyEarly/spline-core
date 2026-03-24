---
layout: default
title: distribution
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 7
mathjax: true
---

#  distribution

Error model used while fitting the tensor spline.


---

## Discussion

  The `distribution` object defines how residuals are converted into
  per-observation variances and, optionally, a correlation model. It
  therefore controls the weight matrix in the objective

  $$
  (y - \mathbf{B}\xi)^T W (y - \mathbf{B}\xi).
  $$


