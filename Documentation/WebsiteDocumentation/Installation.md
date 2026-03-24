---
layout: default
title: Installation
nav_order: 2
description: Installation instructions
permalink: /installation
---

# Installation

Install `Spline Core` either as part of
[OceanKit](https://github.com/JeffreyEarly/OceanKit) or directly from the
[GitHub repository](https://github.com/JeffreyEarly/spline-core).

## Runtime requirements

- MATLAB R2024b or newer
- the `Distributions` package for fitting workflows

## Install from Git

Clone the repository:

```text
git clone https://github.com/JeffreyEarly/spline-core.git
```

Then install from within MATLAB:

```matlab
mpminstall("local/path/to/spline-core");
```

If you already manage dependencies yourself, skip dependency installation:

```matlab
mpminstall("local/path/to/spline-core", InstallDependencies=false);
```

## Development and documentation

For ordinary use, the package itself plus runtime dependencies are enough.
If you want to rebuild the website documentation, also install the
`class-docs` tooling used by this repository.
