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

kpackagetool6 -t Plasma/Applet -r "${PLUGIN_ID}" 2>/dev/null || true

echo "Uninstalled. Restart plasma with:"
echo "  systemctl --user restart plasma-plasmashell.service"
