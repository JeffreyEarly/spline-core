---
layout: default
title: Installation
nav_order: 2
description: Installation instructions"
permalink: /installation
---

## Installation

You may install this as part of [OceanKit](https://github.com/JeffreyEarly/OceanKit), or directly from [the GitHub repository](https://github.com/JeffreyEarly/spline-core) using the command line,
```
git clone https://github.com/JeffreyEarly/spline-core.git
```
Then install the package from within MATLAB
```matlab
mpminstall("local/path/to/spline-core");
```
with authoring enabled.

The package depends on `Distributions`. If you already manage dependencies
yourself, or want to skip dependency installation during development, run
the installer without dependencies,
```matlab
mpminstall("local/path/to/spline-core", InstallDependencies=false);
```
