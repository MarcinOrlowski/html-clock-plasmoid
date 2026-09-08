#!/bin/bash
# ==============================================================================
#
# Monolith MHL: Beautiful animated wallpapers for Plasma 6
#
# @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
# @copyright 2020-2026 Marcin Orlowski
# @license   http://www.opensource.org/licenses/mit-license.php MIT
# @link      https://github.com/MarcinOrlowski/plasmoid-tools
#
# ==============================================================================
#
# Creates <PLASMOID_ROOT>/contents/js/meta.js file with plasmoid metadata.
#

set -euo pipefail

# shellcheck disable=SC2155
declare -r ROOT_DIR="$(realpath "$(dirname "$(realpath "${0}")")/..")"
# shellcheck disable=SC1091  # sourced at runtime; path resolved relative to ROOT_DIR
source "${ROOT_DIR}/bin/common.sh"

declare -r meta_file="${PLASMOID_ROOT}/contents/js/meta.js"
mkdir -p "$(dirname "${meta_file}")"
dumpMeta > "${meta_file}"

echo "Meta data file created: ${meta_file}"
