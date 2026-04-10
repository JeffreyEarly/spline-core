---
layout: default
title: gridVectors
parent: InterpolatingSpline
grand_parent: Classes
nav_order: 4
mathjax: true
---

#  gridVectors

Grid vectors used to define the interpolation lattice.


---

## Discussion

  These are the original 1-D sample locations in each coordinate
  direction. In one dimension `gridVectors` contains one column
  vector; in higher dimensions it stores one grid vector per tensor
  axis.

  If `[X1,...,Xd] = ndgrid(gridVectors{:})`, then the spline
  interpolates the supplied value array exactly on that lattice.


