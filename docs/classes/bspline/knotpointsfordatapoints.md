---
layout: default
title: knotPointsForDataPoints
parent: BSpline
grand_parent: Classes
nav_order: 14
mathjax: true
---

#  knotPointsForDataPoints

Construct a terminated knot sequence from sample locations.


---

## Declaration
```matlab
 knotPoints = knotPointsForDataPoints(dataPoints, options)
```
## Parameters
+ `dataPoints`  observation times (N)
+ `options.S`  (optional) spline degree
+ `options.splineDOF`  (optional) approximate target number of splines

## Returns
+ `knotPoints`  vector of knot point locations

## Discussion

  Use this helper to choose a knot sequence directly from sample
  locations before interpolation or least-squares fitting.

  The implementation sorts the sample locations, optionally subsamples them
  to target `splineDOF`, constructs pseudo-sites on that reduced grid, then
  repeats the first and last knot values `S+1` times so the spline basis is
  terminated at the interval endpoints.

  When `splineDOF` is supplied, the current implementation chooses the
  sample stride as

  $$
  \Delta n = \left\lceil \frac{N}{\max(\mathrm{splineDOF}, S+1)} \right\rceil,
  $$

  where $$N = \mathrm{numel}(t)$$.

  To recover the old `dataDOF=d` behavior, convert it to
  `splineDOF = max(S+1, ceil(numel(t)/d))`:

  ```matlab
  oldDataDOF = 3;
  S = 3;
  splineDOF = max(S+1, ceil(numel(t)/oldDataDOF));
  knotPoints = BSpline.knotPointsForDataPoints(t, S=S, splineDOF=splineDOF);
  ```

  ```matlab
  knotPoints = BSpline.knotPointsForDataPoints(t, S=3);
  X = BSpline.matrixForDataPoints(t, knotPoints=knotPoints, S=3);
  xi = X \ x;
  spline = BSpline(S=3, knotPoints=knotPoints, xi=xi);
  ```


