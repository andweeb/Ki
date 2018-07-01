#!/bin/bash
#
# Create and symlink dist folder to spoons folder

SPOON="Ki.spoon"
WORKING_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$WORKING_DIR/src"
DIST_DIR="$WORKING_DIR/dist"
BUILD_DIR="$DIST_DIR/build"
LINK_TARGET="$HOME/.hammerspoon/Spoons/$SPOON"

build() {
    # Clear out dist folder
    if [ ! -z "$DIST_DIR" ]; then
        rm -rfv "${DIST_DIR:?}"/*
        echo "build.sh: Cleared out content in dist folder"
    fi
    mkdir -p "$BUILD_DIR"

    # Copy dependencies from root directory to folder
    if [ ! -d "$WORKING_DIR/deps" ]; then
        make install-deps
    fi
    cp -r "$WORKING_DIR/deps" "$BUILD_DIR/deps"
    echo "build.sh: Copied all project dependencies to deps folder"

    # Copy source files and generated docs from root directory to folder
    (cd "$SRC_DIR" && for file in *.lua; do cp "$file" "$BUILD_DIR/$file"; done)
    if [ -f "$WORKING_DIR/docs.json" ]; then
        cp "$WORKING_DIR/docs.json" "$BUILD_DIR/docs.json"
    fi
    cp -r "$WORKING_DIR/src/osascripts" "$BUILD_DIR/osascripts"
    echo "build.sh: Copied all source files and docs to dist folder"

    # Remove pre-existing spoon link
    if [ -d "$LINK_TARGET" ]; then
        rm -rv "$LINK_TARGET"
        echo "build.sh: Removed pre-existing Ki spoon"
    fi

    # Symlink dist folder to spoons folder
    ln -sf "$BUILD_DIR" "$LINK_TARGET"
    echo "build.sh: Symlinked dist folder to spoons folder"
}

build
