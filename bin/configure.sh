#!/bin/bash

# HTML Clock Plasmoid for KDE
#
# @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
# @copyright 2020 Marcin Orlowski
# @license   http://www.opensource.org/licenses/mit-license.php MIT
# @link      https://github.com/MarcinOrlowski/htmlclock-plasmoid
#
# Updates plasmoid generated config files file based on current template,
# env vars and metadata.desktop file
#

set -euo pipefail

# shellcheck disable=SC2155
declare -r ROOT_DIR="$(realpath "$(dirname "$(realpath "${0}")")/..")"
source "${ROOT_DIR}/bin/common.sh"

function configurePlasmoid() {
	local -r meta="${ROOT_DIR}/src/contents/js/meta.js"
	echo "Populating ${meta}"
	dumpMeta > "${meta}"

	local -r base="${ROOT_DIR}/src/contents/config/"
	local -r cfg_template_file="${base}/main-template.xml"
	local -r cfg_config_file="${base}/main.xml"

	if [[ ! -s "${cfg_template_file}" ]]; then
		echo "*** Config template file not found: ${cfg_template_file}"
		exit 1
	fi

	local op_api_url=
	local op_api_key=
	local op_snapshot_url=

	if [[ "$#" -eq 0 ]]; then
		echo "Populating config with env vars: ${cfg_config_file}"

		for name in OCTOPRINT_API_URL OCTOPRINT_API_KEY OCTOPRINT_SNAPSHOT_URL; do
			val="$(eval echo "\${${name}}")"
			if [[ -z "${val}" ]]; then
				echo "*** ${name} env variable is not set properly."
				exit 1
			fi

			echo "  ${name}=\"${val}\""
		done

		op_api_url=$(escape "${OCTOPRINT_API_URL}")
		op_api_key=$(escape "${OCTOPRINT_API_KEY}")
		op_snapshot_url=$(escape "${OCTOPRINT_SNAPSHOT_URL}")
	else
		echo "Creating EMPTY config file: ${cfg_config_file}"
	fi

	cat "${cfg_template_file}" | sed -e "s/{OCTOPRINT_API_URL}/${op_api_url}/g" | sed -e "s/{OCTOPRINT_API_KEY}/${op_api_key}/g" | sed -e "s/{OCTOPRINT_SNAPSHOT_URL}/${op_snapshot_url}/g" > "${cfg_config_file}"
}

configurePlasmoid
