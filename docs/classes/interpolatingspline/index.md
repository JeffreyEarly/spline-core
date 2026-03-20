---
layout: default
title: InterpolatingSpline
has_children: false
has_toc: false
mathjax: true
parent: Class documentation
nav_order: 2
---

#  InterpolatingSpline

Interpolating spline fit through data values.


---

## Declaration

<div class="language-matlab highlighter-rouge"><div class="highlight"><pre class="highlight"><code>classdef InterpolatingSpline < BSpline</code></pre></div></div>

## Overview
 
Supported construction forms:
  f = InterpolatingSpline(t,x)
  f = InterpolatingSpline(t,x,K=K)
  f = InterpolatingSpline(t,x,S=S)
 
The constructor chooses a terminated knot sequence from the supplied
sample locations and solves for coefficients that interpolate the
provided values exactly.
 
    


## Topics
+ Initialization
  + [`InterpolatingSpline`](/spline-core/classes/interpolatingspline/interpolatingspline.html) Create an interpolating spline through samples x observed at t.
+ Utility
  + [`splineOrderFromOptions`](/spline-core/classes/interpolatingspline/splineorderfromoptions.html) Resolve spline order from mutually exclusive K and S options.


---