#!/bin/bash

# ==============================================================================
#
# Monolith MHL: Beautiful animated wallpapers for Plasma 6
#
# @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
# @copyright 2025-2026 Marcin Orlowski
# @license   http://www.opensource.org/licenses/mit-license.php MIT
# @link      https://github.com/MarcinOrlowski/plasmoid-tools
#
# ==============================================================================

set -e

SRC_DIR="$(dirname "$0")/../src"
PLUGIN_ID="$(jq -r .KPlugin.Id "${SRC_DIR}/metadata.json")"

# Regenerate runtime metadata (contents/js/meta.js) so the installed package
# always carries up-to-date version/author info from metadata.json.
BIN_DIR="$(cd "$(dirname "$0")" && pwd)"
( cd "${BIN_DIR}/.." && "${BIN_DIR}/meta.sh" )

# Remove old version if installed (in blind)
kpackagetool6 -t Plasma/Applet -r "${PLUGIN_ID}" 2>/dev/null || true
# Install
kpackagetool6 -t Plasma/Applet -i "${SRC_DIR}"

echo "Installed. Restart plasma with:"
echo "  systemctl --user restart plasma-plasmashell.service"
