---
layout: default
title: pointConstraints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 17
mathjax: true
---

#  pointConstraints

Local point constraints used during fitting.


---

## Discussion

  These constraints are compiled into rows of
  `Aeq * xi = beq` or `Aineq * xi <= bineq` by evaluating the spline
  basis or its derivatives at specified points.


