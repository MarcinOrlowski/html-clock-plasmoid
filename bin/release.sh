#!/bin/bash

# HTML Clock Plasmoid for KDE
#
# @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
# @copyright 2020 Marcin Orlowski
# @license   http://www.opensource.org/licenses/mit-license.php MIT
# @link      https://github.com/MarcinOrlowski/htmlclock-plasmoid
#
# Builds public release distributable plasmoid archive
#

set -euo pipefail

# shellcheck disable=SC2155
declare -r ROOT_DIR="$(realpath "$(dirname "$(realpath "${0}")")/..")"
source "${ROOT_DIR}/bin/common.sh"

function releasePlasmoid() {
	local -r plasmoid_file_name="$(getPlasmoidFileName)"
	local -r target_file="$(pwd)/${plasmoid_file_name}"
	if [[ -f "${target_file}" ]]; then
		echo "*** File already exists: ${target_file}"
		exit 1
	fi

	local -r tmp="$(mktemp -d "/tmp/${plasmoid_file_name}.XXXXXX")"
	cp -a "${ROOT_DIR}"/src/* "${tmp}"

	local op_api_url=
	local op_api_key=
	local op_snapshot_url=
	local -r cfg_template_file="${tmp}/contents/config/main-template.xml"
	local -r cfg_config_file="${tmp}/contents/config/main.xml"

	pushd "${tmp}" > /dev/null
	cat "${cfg_template_file}" | sed -e "s/{OCTOPRINT_API_URL}/${op_api_url}/g" | sed -e "s/{OCTOPRINT_API_KEY}/${op_api_key}/g" | sed -e "s/{OCTOPRINT_SNAPSHOT_URL}/${op_snapshot_url}/g" > "${cfg_config_file}"
	rm -vf "${cfg_template_file}"

	dumpMeta > "${tmp}/contents/js/meta.js"

	zip -q -r "${target_file}" -- *
	ls -ld "${target_file}"

	popd > /dev/null

	rm -rf "${tmp}"
}

releasePlasmoid
