# ============================================================
# Makefile for coord_kit OpenSCAD Library
# ============================================================
# Simplified Makefile - actual logic lives in scripts/
#
# Usage:
#   make          - Build documentation and images
#   make docs     - Generate API documentation
#   make images   - Render example and test images
#   make test     - Run test suite
#   make setup    - Setup development environment
#   make clean    - Remove build artifacts
#   make help     - Show this help

# ============================================================
# CONFIGURATION
# ============================================================

SCRIPTS_DIR := scripts

# Directories
BUILD_DIR := build
DOCS_DIR := docs

# ============================================================
# DEFAULT TARGET
# ============================================================

.PHONY: all
all: docs images
	@echo "✓ Build complete!"

# ============================================================
# BUILD TARGETS
# ============================================================

.PHONY: docs
docs:
	@$(SCRIPTS_DIR)/generate_docs.sh

.PHONY: images
images:
	@$(SCRIPTS_DIR)/render_images.sh

.PHONY: examples
examples:
	@$(SCRIPTS_DIR)/render_images.sh --examples-only

.PHONY: test-images
test-images:
	@$(SCRIPTS_DIR)/render_images.sh --tests-only

# ============================================================
# TEST TARGETS
# ============================================================

.PHONY: test
test:
	@$(SCRIPTS_DIR)/run_tests.sh

# ============================================================
# SETUP TARGETS
# ============================================================

.PHONY: setup
setup:
	@$(SCRIPTS_DIR)/setup.sh

# ============================================================
# CLEANING
# ============================================================

.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "✓ Build artifacts removed"

.PHONY: clean-docs
clean-docs:
	@echo "Cleaning generated documentation..."
	@rm -rf $(DOCS_DIR)
	@echo "✓ Documentation removed"
	
.PHONY: clean-all
clean-all: clean clean-docs
	@echo "✓ All generated files removed"


# ============================================================
# UTILITY TARGETS
# ============================================================

.PHONY: help
help:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "coord_kit - Makefile Help"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "Setup:"
	@echo "  make setup        Setup development environment (venv, tools)"
	@echo ""
	@echo "Build:"
	@echo "  make              Build documentation and all images"
	@echo "  make docs         Generate API documentation"
	@echo "  make images       Render example and test images"
	@echo "  make examples     Render only example images"
	@echo "  make test-images  Render only test images"
	@echo ""
	@echo "Test:"
	@echo "  make test         Run test suite"
	@echo ""
	@echo "Clean:"
	@echo "  make clean        Remove build artifacts (preserves docs)"
	@echo "  make clean-all    Remove build artifacts and docs"
	@echo "  make clean-docs   Remove only generated docs"
	@echo ""
	@echo "Info:"
	@echo "  make help         Show this help message"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "First time setup:"
	@echo "  1. make setup"
	@echo "  2. make"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
