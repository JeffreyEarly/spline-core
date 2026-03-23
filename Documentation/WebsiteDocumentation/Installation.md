---
layout: default
title: Installation
nav_order: 2
description: Installation instructions
permalink: /installation
---

# Installation

You may install `spline-core` as part of
[OceanKit](https://github.com/JeffreyEarly/OceanKit), or directly from the
[GitHub repository](https://github.com/JeffreyEarly/spline-core).

## Runtime requirements

- a recent MATLAB release with support for modern `arguments` blocks and name-value syntax
- the `Distributions` package for runtime fitting workflows

## Install from Git

Clone the repository,

```
git clone https://github.com/JeffreyEarly/spline-core.git
```

then install the package from within MATLAB:

```matlab
mpminstall("local/path/to/spline-core");
```

The package depends on `Distributions`. If you already manage dependencies
yourself, or want to skip dependency installation during development, run
the installer without dependencies:

```matlab
mpminstall("local/path/to/spline-core", InstallDependencies=false);
```

## Development and documentation

For ordinary use, the package itself plus runtime dependencies are enough.
If you want to rebuild the website documentation, you will also need the
`class-docs` tooling used by this repository.
