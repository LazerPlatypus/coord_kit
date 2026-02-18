#!/usr/bin/env bash
# Setup script for coord_kit development environment
# Creates Python venv and installs openscad-docsgen

set -e

VENV_DIR=".venv"

echo "Setting up coord_kit development environment..."
echo ""

# Check if OpenSCAD is installed
if ! command -v openscad &> /dev/null; then
    echo "❌ OpenSCAD not found in PATH"
    echo "   Install from: https://openscad.org/"
    exit 1
fi
echo "✓ OpenSCAD found: $(openscad --version 2>&1 | head -1)"

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found in PATH"
    exit 1
fi
echo "✓ Python found: $(python3 --version)"
echo ""

# Create or verify venv
if [ -d "$VENV_DIR" ]; then
    echo "✓ Virtual environment already exists at $VENV_DIR/"
else
    echo "Creating virtual environment at $VENV_DIR/..."
    python3 -m venv "$VENV_DIR"
    echo "✓ Virtual environment created"
fi
echo ""

# Install/upgrade openscad-docsgen
echo "Installing openscad-docsgen..."
"$VENV_DIR/bin/pip" install --quiet --upgrade pip
"$VENV_DIR/bin/pip" install --quiet openscad-docsgen
echo "✓ openscad-docsgen installed"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Setup complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "The Makefile will automatically use the venv installation."
echo ""
echo "To manually activate the venv:"
echo "  source $VENV_DIR/bin/activate"
echo ""
echo "To deactivate:"
echo "  deactivate"
echo ""
