---
layout: default
title: ShapeConstraint
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 7
---

#  ShapeConstraint

Enumerate supported global shape constraints for constrained splines.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef ShapeConstraint</code></pre></div></div>

## Overview
 
These values are interpreted by ConstrainedSpline when constructing
global inequality constraints on spline coefficients.
 
## Basic usage
 
Use these enumeration values when selecting a global shape
constraint for `ConstrainedSpline`.
 
```matlab
constraints.global = ShapeConstraint.monotonicIncreasing;
spline = ConstrainedSpline(t, x, 4, tKnot, [], constraints);
```
 
  


## Topics
+ Choose a shape constraint
  + [`ShapeConstraint`](/spline-core/classes/shapeconstraint/shapeconstraint.html) Enumerate supported global shape constraints for constrained splines.


---