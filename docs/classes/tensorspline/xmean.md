---
layout: default
title: xMean
parent: TensorSpline
grand_parent: Classes
nav_order: 21
mathjax: true
---

#  xMean

Mean added back to zero-order evaluations.


---

## Discussion

  `xMean` is the additive term in the stored tensor-product model

  $$
  f(x_1,\ldots,x_d) = x_{\mathrm{Mean}} + x_{\mathrm{Std}}
  \sum_{j_1,\ldots,j_d} \xi_{j_1,\ldots,j_d}
  \prod_{k=1}^{d} B_{j_k,S_k}(x_k;\tau_k).
  $$

  It is mainly a numerical device: large offsets can be removed
  before solving for `xi`, then added back only during zero-order
  evaluation. As in the 1-D case, derivatives are unaffected by
  `xMean`.

  ```matlab
  spline = TensorSpline(S=[3 3], knotPoints=knotPoints, xi=xi, xMean=2.1, xStd=0.4);
  values = spline(Xq, Yq);
  ```


