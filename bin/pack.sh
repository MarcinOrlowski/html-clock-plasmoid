#!/bin/bash

# HTML Clock Plasmoid for KDE
#
# @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
# @copyright 2020 Marcin Orlowski
# @license   http://www.opensource.org/licenses/mit-license.php MIT
# @link      https://github.com/MarcinOrlowski/htmlclock-plasmoid
#
#  Packs plasmoid into distributable archive
#

set -euo pipefail

# shellcheck disable=SC2155
declare -r ROOT_DIR="$(realpath "$(dirname "$(realpath "${0}")")/..")"
source "${ROOT_DIR}/bin/common.sh"

function packPlasmoid() {
	pushd "${ROOT_DIR}/src" > /dev/null

	local -r plasmoid_file="$(pwd)/$(getPlasmoidFileName)"
	zip -q -r "${plasmoid_file}" -- *
	ls -ld "${plasmoid_file}"

	popd > /dev/null
}

packPlasmoid

