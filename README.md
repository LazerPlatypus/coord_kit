# coord_kit

A coordinate-based geometry manipulation library for OpenSCAD.

## Overview

`coord_kit` provides functions for working with 2D and 3D coordinates in OpenSCAD, including point generation, transformation, and extrusion utilities.

**Key Features:**
- Point-based geometry creation
- Coordinate transformation utilities
- Advanced extrusion functions
- Clean, documented API

## Installation

### Method 1: Git Submodule (Recommended)

Add to your project as a git submodule:

```bash
cd your-project
git submodule add https://github.com/yourusername/coord_kit.git deps/coord_kit
git submodule update --init --recursive
```

### Method 2: Direct Download

Download and place in your OpenSCAD library directory:
- **Linux:** `~/.local/share/OpenSCAD/libraries/`
- **macOS:** `~/Documents/OpenSCAD/libraries/`
- **Windows:** `My Documents\OpenSCAD\libraries\`

## Quick Start

### If installed as submodule (recommended):

```scad
include <deps/coord_kit/core.scad>

// Use coord_kit functions
points = make_circle_points(radius=10, segments=32);
polygon(points);
```

### If installed in OpenSCAD libraries directory:

```scad
include <coord_kit/core.scad>

// Use coord_kit functions
points = make_circle_points(radius=10, segments=32);
polygon(points);
```

## Documentation

- **[API Reference](docs/)** - Complete function and module documentation
- **[Examples](examples/)** - Usage examples with rendered images

## Development

### Setup

First-time setup of development environment:

```bash
make setup
```

This creates a Python virtual environment and installs `openscad-docsgen` for documentation generation.

### Building

```bash
# Build everything (docs + images)
make

# Build documentation only
make docs

# Render example images
make images

# Run tests
make test
```

### Project Structure

```
coord_kit/
├── core.scad              # Main entry point
├── src/                   # Source modules
│   ├── extrude.scad      # Extrusion utilities
│   └── points.scad       # Point generation
├── examples/              # Usage examples
├── tests/                 # Test files
├── docs/                  # Generated documentation
├── deps/                  # Dependencies (submodules)
├── scripts/               # Build scripts
└── Makefile              # Build automation
```

## Usage Examples

### Creating Points

```scad
include <deps/coord_kit/core.scad>

// Generate circle points
circle_points = make_circle_points(radius=10, segments=32);
polygon(circle_points);

// Generate arc points
arc_points = make_arc_points(radius=10, start_angle=0, end_angle=90);
polygon(arc_points);
```

### Extrusion

```scad
include <deps/coord_kit/core.scad>

// Extrude along path
path = [[0,0], [10,0], [10,10], [0,10]];
profile = circle(r=1);
extrude_along_path(path, profile);
```

See [examples/](examples/) for more complete examples.

## Dependencies

- **OpenSCAD** 2021.01 or newer
- **Python 3** (for documentation generation only)
- **openscad-docsgen** (installed automatically with `make setup`)

Optional dependencies in `deps/` are included as git submodules.

## Contributing

Contributions welcome! Please:

1. Follow the [OpenSCAD Style Guide](../openscad_guide/)
2. Document all public functions using openscad_docsgen format
3. Add examples for new features
4. Run tests before submitting: `make test`

## License

This project is licensed under the **CERN Open Hardware License Version 2 – Strongly Reciprocal (CERN-OHL-S v2)**.

**Summary:**
- ✓ Use, modify, and manufacture (including commercially)
- ✓ Distribute original or modified versions
- ⚠️ Modified versions must use the same license
- ⚠️ Must provide complete source for any distributed modifications

Full license text available in the [LICENSE](LICENSE) file.

## Support

- **Issues:** [GitHub Issues](https://github.com/yourusername/coord_kit/issues)
- **Discussions:** [GitHub Discussions](https://github.com/yourusername/coord_kit/discussions)
- **Documentation:** [docs/](docs/)

---

**Status:** Active development
**Version:** 0.1.0 (pre-release)
