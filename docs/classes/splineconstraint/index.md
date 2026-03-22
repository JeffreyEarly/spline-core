---
layout: default
title: SplineConstraint
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 7
---

#  SplineConstraint

Common superclass for local and global spline constraint objects.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef SplineConstraint < matlab.mixin.Heterogeneous</code></pre></div></div>

## Overview
 
Use `SplineConstraint` when you want to pass a mixed array of
`PointConstraint` and `GlobalConstraint` objects through one API.
 
```matlab
constraints = [
    PointConstraint.equal(0, D=1, Value=0)
    GlobalConstraint.positive()
];
```
 
  


## Topics
+ Specify constraints
  + [`SplineConstraint`](/spline-core/classes/splineconstraint/splineconstraint.html) Common superclass for local and global spline constraint objects.


---