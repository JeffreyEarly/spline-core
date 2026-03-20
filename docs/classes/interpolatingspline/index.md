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
 
## Basic usage
 
Use `InterpolatingSpline` when you want a spline that passes exactly
through one-dimensional sample values.
 
```matlab
t = linspace(0,1,12)';
x = sin(2*pi*t);
spline = InterpolatingSpline(t, x);
 
xq = spline(linspace(0,1,100)');
```
 
    


## Topics
+ Create an interpolating spline
  + [`InterpolatingSpline`](/spline-core/classes/interpolatingspline/interpolatingspline.html) Create an interpolating spline through samples x observed at t.
+ Choose spline order
  + [`splineOrderFromOptions`](/spline-core/classes/interpolatingspline/splineorderfromoptions.html) Resolve spline order from mutually exclusive K and S options.


---