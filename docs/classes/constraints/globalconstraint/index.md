---
layout: default
title: GlobalConstraint
has_children: false
has_toc: false
mathjax: true
parent: Constraint classes
nav_order: 3
---

#  GlobalConstraint

Specify a global shape constraint for a constrained spline fit.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef GlobalConstraint</code></pre></div></div>

## Overview

Use `GlobalConstraint` to describe semantic whole-domain constraints
such as positivity or monotonicity. These objects are intended to be
compiled into linear coefficient inequalities by constrained fitting
classes.

## Basic usage

```matlab
c1 = GlobalConstraint.positive();
c2 = GlobalConstraint.monotonicIncreasing(dimension=2);
```




## Topics
+ Specify global constraints
  + [`GlobalConstraint`](/spline-core/classes/constraints/globalconstraint/globalconstraint.html) Create a global constraint specification.
  + [`monotonicDecreasing`](/spline-core/classes/constraints/globalconstraint/monotonicdecreasing.html) Create a monotone-decreasing constraint along one dimension.
  + [`monotonicIncreasing`](/spline-core/classes/constraints/globalconstraint/monotonicincreasing.html) Create a monotone-increasing constraint along one dimension.
  + [`none`](/spline-core/classes/constraints/globalconstraint/none.html) Create an explicit no-op global constraint.
  + [`positive`](/spline-core/classes/constraints/globalconstraint/positive.html) Create a positivity constraint.
+ Inspect global constraint properties
  + [`dimension`](/spline-core/classes/constraints/globalconstraint/dimension.html) Tensor dimension associated with the constraint, when applicable.
  + [`shape`](/spline-core/classes/constraints/globalconstraint/shape.html) constraint kind.


---