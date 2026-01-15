#!/bin/bash
#
# Compiles .po translation files to binary .mo format
# For Plasma 6 widgets using metadata.json
#

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_ROOT="$DIR/.."
PROJECT_NAME="plasma_applet_$(grep -oP '"Id":\s*"\K[^"]+' "$PACKAGE_ROOT/metadata.json")"

echo "Project: $PROJECT_NAME"
echo "Building translation files..."

LOCALE_DIR="$PACKAGE_ROOT/contents/locale"

# Process each .po file
for PO_FILE in "$DIR"/*.po; do
    if [ -f "$PO_FILE" ]; then
        LOCALE=$(basename "$PO_FILE" .po)
        MO_DIR="$LOCALE_DIR/$LOCALE/LC_MESSAGES"
        MO_FILE="$MO_DIR/$PROJECT_NAME.mo"

        echo "Compiling: $LOCALE"
        mkdir -p "$MO_DIR"
        msgfmt -o "$MO_FILE" "$PO_FILE"
        echo "  -> $MO_FILE"
    fi
done

if [ ! -d "$LOCALE_DIR" ] || [ -z "$(ls -A "$LOCALE_DIR" 2>/dev/null)" ]; then
    echo "No .po files found. Create translations first."
    echo "Example: cp template.pot nl.po && edit nl.po"
else
    echo "Done! Translations built in $LOCALE_DIR"
fi
