---
layout: default
title: dataPoints
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 5
mathjax: true
---

#  dataPoints

Observation locations as an N-by-D point matrix.


---

## Description
Real valued property with dimensions $$(dataPointIndex,dataDimension)$$ and no units.

## Discussion

  Each row is one observation location in physical coordinates. For
  gridded inputs, `dataPoints` is the explicit point-matrix form of
  [`gridVectors`](/spline-core/classes/constrainedspline/gridvectors.html).


