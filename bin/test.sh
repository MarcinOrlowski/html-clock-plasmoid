#!/bin/bash

# HTML Clock Plasmoid for KDE
#
# @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
# @copyright 2020 Marcin Orlowski
# @license   http://www.opensource.org/licenses/mit-license.php MIT
# @link      https://github.com/MarcinOrlowski/htmlclock-plasmoid
#
#  Runs plasmoid in plasmoidviewer. Pass any argument to run in FullRepresentation, otherwise
#  CompactReperesentation is used.
#

set -euo pipefail

# shellcheck disable=SC2155
declare -r ROOT_DIR="$(realpath "$(dirname "$(realpath "${0}")")/..")"
source "${ROOT_DIR}/bin/common.sh"

function testPlasmoid() {
	# https://stackoverflow.com/questions/41409273/file-line-and-function-for-qml-files
	# https://doc.qt.io/qt-5/qtglobal.html#qSetMessagePattern
	#export QT_MESSAGE_PATTERN="[%{type}] %{appname} (%{file}:%{line}) - %{message}"
	#export QT_MESSAGE_PATTERN="%{time} %{file}:%{line}: %{message}"
	export QT_MESSAGE_PATTERN="%{time} L%{line} %{message}"

	if [[ $# -ge 1 ]]; then
		echo "Running FullRepresentation"
		plasmoidviewer --applet "${ROOT_DIR}/src"
	else
		echo "Running CompactRepresentation"
		plasmoidviewer \
    		--formfactor vertical \
		    --location topedge \
		    --applet "${ROOT_DIR}/src" \
		    --size 140X150 \
	    	#--size "196X96" \
	fi
}

testPlasmoid $@
