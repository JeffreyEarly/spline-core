---
layout: default
title: xi
parent: TensorSpline
grand_parent: Classes
nav_order: 25
mathjax: true
---

#  xi

Tensor-product spline coefficients reshaped to basisSize.


---

## Discussion

  The coefficient array weights the tensor basis in

  $$
  f(x_1,\ldots,x_d) = x_{\mathrm{Mean}} + x_{\mathrm{Std}}
  \sum_{j_1,\ldots,j_d} \xi_{j_1,\ldots,j_d}
  \prod_{k=1}^{d} B_{j_k,S_k}(x_k;\tau_k).
  $$

  `xi` is stored reshaped to
  [`basisSize`](/spline-core/classes/tensorspline/basissize.html),
  so in 2-D it is a matrix, in 3-D it is an array, and so on.
  The matrix-building helper is
  [`matrixForPointMatrix`](/spline-core/classes/tensorspline/matrixforpointmatrix.html).


