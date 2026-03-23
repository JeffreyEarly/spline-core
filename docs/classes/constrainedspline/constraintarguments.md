---
layout: default
title: constraintArguments
parent: ConstrainedSpline
grand_parent: Classes
nav_order: 9
mathjax: true
---

#  constraintArguments

Normalize mixed constraint inputs into constructor arguments.

> Developer documentation: this item describes internal implementation details.


---

## Declaration
```matlab
 [constraintArguments,constrainedValues] = constraintArguments(constraints,sampleValues,options)
```
## Parameters
+ `constraints`  optional mixed SplineConstraint array
+ `sampleValues`  optional vector used for positivity heuristics
+ `options.enforcePositiveIfPossible`  add positivity when sampleValues are nonnegative

## Returns
+ `constraintArguments`  name-value arguments for constructor constraints
+ `constrainedValues`  possibly clipped sample values

## Discussion

                
