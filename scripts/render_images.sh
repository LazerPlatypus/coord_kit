#!/usr/bin/env bash
# Render example and test images using OpenSCAD

set -e

EXAMPLES_DIR="examples"
TESTS_DIR="tests"
BUILD_DIR="build"
BUILD_EXAMPLES_DIR="$BUILD_DIR/examples"
BUILD_TESTS_DIR="$BUILD_DIR/tests"

# Camera and image settings
CAMERA="0,0,0,60,0,45,200"
IMGSIZE="800,600"
COLORSCHEME="Tomorrow"

# Parse arguments
RENDER_EXAMPLES=true
RENDER_TESTS=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --examples-only)
            RENDER_TESTS=false
            shift
            ;;
        --tests-only)
            RENDER_EXAMPLES=false
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--examples-only|--tests-only]"
            exit 1
            ;;
    esac
done

# Check OpenSCAD
if ! command -v openscad &> /dev/null; then
    echo "❌ OpenSCAD not found in PATH"
    exit 1
fi

# Render examples
if [ "$RENDER_EXAMPLES" = true ]; then
    if [ -d "$EXAMPLES_DIR" ] && [ -n "$(ls -A $EXAMPLES_DIR/*.scad 2>/dev/null)" ]; then
        echo "Rendering example images..."
        mkdir -p "$BUILD_EXAMPLES_DIR"

        for scad_file in "$EXAMPLES_DIR"/*.scad; do
            if [ -f "$scad_file" ]; then
                basename=$(basename "$scad_file" .scad)
                output="$BUILD_EXAMPLES_DIR/${basename}.png"
                echo "  → $basename.png"

                openscad --hardwarnings \
                    --camera="$CAMERA" \
                    --imgsize="$IMGSIZE" \
                    --colorscheme="$COLORSCHEME" \
                    -o "$output" "$scad_file" 2>&1 | grep -v "^$" || true
            fi
        done
        echo "✓ Example images rendered to $BUILD_EXAMPLES_DIR/"
    else
        echo "No example files found in $EXAMPLES_DIR/"
    fi
fi

# Render tests
if [ "$RENDER_TESTS" = true ]; then
    if [ -d "$TESTS_DIR" ] && [ -n "$(ls -A $TESTS_DIR/*.scad 2>/dev/null)" ]; then
        echo "Rendering test images..."
        mkdir -p "$BUILD_TESTS_DIR"

        for scad_file in "$TESTS_DIR"/*.scad; do
            if [ -f "$scad_file" ]; then
                basename=$(basename "$scad_file" .scad)
                output="$BUILD_TESTS_DIR/${basename}.png"
                echo "  → $basename.png"

                openscad --hardwarnings \
                    --camera="$CAMERA" \
                    --imgsize="$IMGSIZE" \
                    --colorscheme="$COLORSCHEME" \
                    -o "$output" "$scad_file" 2>&1 | grep -v "^$" || true
            fi
        done
        echo "✓ Test images rendered to $BUILD_TESTS_DIR/"
    else
        echo "No test files found in $TESTS_DIR/"
    fi
fi

echo "✓ Image rendering complete!"
