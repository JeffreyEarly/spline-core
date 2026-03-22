---
layout: default
title: PointConstraint
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 8
---

#  PointConstraint

Specify local equality or bound constraints at one or more points.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef PointConstraint</code></pre></div></div>

## Overview
 
Use `PointConstraint` to declare values or derivative conditions at
specific points in one or more dimensions. A single constraint object
can represent many points at once, which makes it suitable for both
simple one-dimensional constraints and large masked regions in tensor
fits.
 
## Basic usage
 
```matlab
c1 = PointConstraint.equal((0:10)', D=2, Value=0);
c2 = PointConstraint.lowerBound([X(mask), Y(mask)], D=[0 0], Value=0);
c3 = PointConstraint.equalOnMask({x,y}, islandMask, D=[0 0], Value=0);
```
 
  


## Topics
+ Specify point constraints
  + [`PointConstraint`](/spline-core/classes/pointconstraint/pointconstraint.html) Create a pointwise equality or bound constraint.
  + [`equal`](/spline-core/classes/pointconstraint/equal.html) Create a pointwise equality constraint.
  + [`equalOnMask`](/spline-core/classes/pointconstraint/equalonmask.html) Create a pointwise equality constraint from a logical mask.
  + [`lowerBound`](/spline-core/classes/pointconstraint/lowerbound.html) Create a pointwise lower-bound constraint.
  + [`lowerBoundOnMask`](/spline-core/classes/pointconstraint/lowerboundonmask.html) Create a pointwise lower-bound constraint from a logical mask.
  + [`upperBound`](/spline-core/classes/pointconstraint/upperbound.html) Create a pointwise upper-bound constraint.
  + [`upperBoundOnMask`](/spline-core/classes/pointconstraint/upperboundonmask.html) Create a pointwise upper-bound constraint from a logical mask.
+ Inspect point constraint properties
  + [`D`](/spline-core/classes/pointconstraint/d.html) Derivative orders as an N-by-D matrix.
  + [`Points`](/spline-core/classes/pointconstraint/points.html) Constraint locations as an N-by-D point matrix.
  + [`Relation`](/spline-core/classes/pointconstraint/relation.html) Constraint relation: "==", ">=", or "<=".
  + [`Value`](/spline-core/classes/pointconstraint/value.html) Target values as an N-by-1 vector.
  + [`numConstraints`](/spline-core/classes/pointconstraint/numconstraints.html) Number of constrained points.
  + [`numDimensions`](/spline-core/classes/pointconstraint/numdimensions.html) Number of constrained dimensions.


---