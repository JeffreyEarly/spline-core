---
layout: default
title: GlobalConstraint
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 8
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
c2 = GlobalConstraint.monotonicIncreasing(Dimension=2);
```
 
  


## Topics
+ Specify global constraints
  + [`GlobalConstraint`](/spline-core/classes/globalconstraint/globalconstraint.html) Create a global constraint specification.
  + [`monotonicDecreasing`](/spline-core/classes/globalconstraint/monotonicdecreasing.html) Create a monotone-decreasing constraint along one dimension.
  + [`monotonicIncreasing`](/spline-core/classes/globalconstraint/monotonicincreasing.html) Create a monotone-increasing constraint along one dimension.
  + [`none`](/spline-core/classes/globalconstraint/none.html) Create an explicit no-op global constraint.
  + [`positive`](/spline-core/classes/globalconstraint/positive.html) Create a positivity constraint.
+ Inspect global constraint properties
  + [`Dimension`](/spline-core/classes/globalconstraint/dimension.html) Tensor dimension associated with the constraint, when applicable.
  + [`Shape`](/spline-core/classes/globalconstraint/shape.html) constraint kind.


---