---
layout: default
title: integralMatrixForDataPoints
parent: BSpline
grand_parent: Classes
nav_order: 11
mathjax: true
---

#  integralMatrixForDataPoints

Return the exact interpolation-to-antiderivative linear map.


---

## Declaration
```matlab
 W = integralMatrixForDataPoints(dataPoints, queryPoints, options)
```
## Parameters
+ `dataPoints`  interpolation sample locations
+ `queryPoints`  points at which to evaluate the antiderivative
+ `options.knotPoints`  terminated knot sequence for the interpolation basis
+ `options.S`  spline degree of the interpolation basis

## Returns
+ `W`  linear map from interpolation values on `dataPoints` to antiderivative values on `queryPoints`

## Discussion

  Use this expert utility when one-dimensional interpolation values are
  sampled on `dataPoints` and the zero-anchored antiderivative should be
  evaluated at `queryPoints` without constructing an intermediate spline
  object.

  If `y` is the column vector of interpolation values and `f` is the
  corresponding exact interpolating spline on the supplied terminated knot
  sequence, then the returned matrix satisfies

  $$
  W y = F(t_q), \qquad
  F(t) = \int_{t_1}^{t} f(s)\,ds.
  $$

  ```matlab
  W = BSpline.integralMatrixForDataPoints(t, tq, knotPoints=knotPoints, S=3);
  valuesInt = W * values;
  ```


