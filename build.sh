#!/bin/bash
#
# Create and link dist folder to spoons folder

SPOON="Ki.spoon"
LINK_TARGET="$HOME/.hammerspoon/Spoons/$SPOON"
CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST="$CWD/dist"

# Generate docs
hs -c "hs.doc.builder.genJSON(\"$CWD\")" | grep -v "^--" > docs.json
echo "build.sh: Generated Ki docs"

# Create or clear out dist folder
if [ -d "$DIST" ] && [ ! -z "$DIST" ]; then
    rm -rfv "${DIST:?}"/*
    echo "build.sh: Cleared out content in dist folder"
else
    mkdir "$DIST"
    echo "build.sh: Created dist folder"
fi

# Copy lua scripts and generated docs from root directory to folder
(cd "$CWD" && for file in *.lua; do cp "$file" "$DIST/$file"; done)
if [ -f "$CWD/docs.json" ]; then
    cp "$CWD/docs.json" "$DIST/docs.json"
fi
cp -r "$CWD/scripts" "$DIST/scripts"
echo "build.sh: Copied all source files and docs to dist folder"

# Remove pre-existing spoon link
if [ -d "$LINK_TARGET" ]; then
    rm -rv "$LINK_TARGET"
    echo "build.sh: Removed pre-existing Ki spoon"
fi

# Symlink dist folder to spoons folder
ln -sf "$DIST" "$LINK_TARGET"
echo "build.sh: Symlinked dist folder to spoons folder"
