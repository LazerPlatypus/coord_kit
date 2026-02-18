#!/usr/bin/env bash
# Generate API documentation using openscad-docsgen
# Automatically detects venv installation or uses system installation

set -e

VENV_DIR=".venv"
DOCS_DIR="docs"
SRC_DIR="src"

# Find openscad-docsgen (venv first, then system)
if [ -x "$VENV_DIR/bin/openscad-docsgen" ]; then
    DOCSGEN="$VENV_DIR/bin/openscad-docsgen"
    echo "Using openscad-docsgen from venv"
elif command -v openscad-docsgen &> /dev/null; then
    DOCSGEN="openscad-docsgen"
    echo "Using system openscad-docsgen"
else
    echo "❌ openscad-docsgen not found"
    echo ""
    echo "Install with:"
    echo "  make setup    # or ./scripts/setup.sh"
    echo ""
    echo "Or install globally:"
    echo "  https://github.com/BelfrySCAD/openscad_docsgen"
    exit 1
fi

echo "Generating API documentation..."
mkdir -p "$DOCS_DIR"

# Run docsgen on all source files
$DOCSGEN -m $SRC_DIR/*.scad --force

echo "✓ Documentation generated in $DOCS_DIR/"
