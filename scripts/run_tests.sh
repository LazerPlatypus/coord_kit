#!/usr/bin/env bash
# Run OpenSCAD tests
# Checks for assertion failures and errors in test files

set -e

TESTS_DIR="tests"
FAILED=0

# Check OpenSCAD
if ! command -v openscad &> /dev/null; then
    echo "❌ OpenSCAD not found in PATH"
    exit 1
fi

# Check for test files
if [ ! -d "$TESTS_DIR" ] || [ -z "$(ls -A $TESTS_DIR/*.scad 2>/dev/null)" ]; then
    echo "No test files found in $TESTS_DIR/"
    echo "Create test files with pattern: $TESTS_DIR/test_*.scad"
    exit 0
fi

echo "Running tests..."
echo ""

# Run each test
for test_file in "$TESTS_DIR"/*.scad; do
    if [ -f "$test_file" ]; then
        test_name=$(basename "$test_file")
        echo "→ Testing $test_name..."

        # Run OpenSCAD and capture output
        if output=$(openscad -o /dev/null "$test_file" 2>&1); then
            # Check for assertion or error messages
            if echo "$output" | grep -qi "assertion\|error"; then
                echo "  ❌ FAILED"
                echo "$output" | grep -i "assertion\|error"
                FAILED=$((FAILED + 1))
            else
                echo "  ✓ PASSED"
            fi
        else
            echo "  ❌ FAILED (OpenSCAD error)"
            echo "$output"
            FAILED=$((FAILED + 1))
        fi
        echo ""
    fi
done

# Summary
if [ $FAILED -eq 0 ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✓ All tests passed!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 0
else
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❌ $FAILED test(s) failed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 1
fi
