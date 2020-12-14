#!/bin/bash

# HTML Clock Plasmoid for KDE
#
# @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
# @copyright 2020 Marcin Orlowski
# @license   http://www.opensource.org/licenses/mit-license.php MIT
# @link      https://github.com/MarcinOrlowski/htmlclock-plasmoid
#
# Runs plasmoid in plasmoidviewer. Pass any argument to run in FullRepresentation, otherwise
# CompactReperesentation is used.
#
# Usage:
# ------
# # shellcheck disable=SC2155
# declare -r ROOT_DIR="$(realpath "$(dirname "$(realpath "${0}")")/..")"
# source "${ROOT_DIR}/bin/common.sh"
#

set -euo pipefail

# ----------------------------------------------------------

function getMetaTag() {
	local -r tag="${1:-}"
	local -r meta_file="${2:-${ROOT_DIR}/src/metadata.desktop}"
	
	echo "$(grep "^${tag}=" < "${meta_file}" | awk '{split($0,a,"="); print a[2]}')"
}

# ----------------------------------------------------------

# Echos some data from metadata.desktop file as JS code. 
# This is to work around limitation of QML not exporting
# metadata unless post v5.76 of framework
function dumpMeta() {
	local -r pkg_version="$(getMetaTag "X-KDE-PluginInfo-Version")"
	local -r author_name="$(getMetaTag "X-KDE-PluginInfo-Author")"
	local -r author_url="$(getMetaTag "X-KDE-PluginInfo-Author-Url")"
	local -r project_name="$(getMetaTag "Name")"
	local -r project_url="$(getMetaTag "X-KDE-PluginInfo-Website")"

#	local -r pkg_name="$(getMetaTag "X-KDE-PluginInfo-Name")"
#	local -r pkg_base_name=$(echo "${pkg_name}" | awk '{cnt=split($0,a,"."); print a[cnt]}')
#	local -r plasmoid_path="$(pwd)"
#	local -r plasmoid_file_name="${pkg_base_name}-${pkg_version}.plasmoid"

# NOTE: redirect to stderr if in need of showing these!
#	echo "  OUTPUT_FILE: ${plasmoid_file_name}"
#	echo "     PKG_NAME: ${pkg_name}"
#	echo " PROJECT_NAME: ${project_name}"
#	echo "  PROJECT_URL: ${project_url}"
#	echo "      VERSION: ${pkg_version}"
#	echo "  AUTHOR_NAME: ${author_name}"
#	echo "   AUTHOR_URL: ${author_url}"

	echo -e "var version=\"${pkg_version}\"\n"\
			"var title=\"${project_name}\"\n"\
			"var url=\"${project_url}\"\n"\
			"var authorName=\"${author_name}\"\n"\
			"var authorUrl=\"${author_url}\"\n"
}

# ----------------------------------------------------------

function getPlasmoidFileName() {
	local -r pkg_version="$(getMetaTag "X-KDE-PluginInfo-Version")"
	local -r pkg_name="$(getMetaTag "X-KDE-PluginInfo-Name")"
	local -r pkg_base_name=$(echo "${pkg_name}" | awk '{cnt=split($0,a,"."); print a[cnt]}')
	echo "${pkg_base_name}-${pkg_version}.plasmoid"
}

# ----------------------------------------------------------

# Escapes given string so it won't be treated as regular expression
# when handed to sed or elsewhere
#
# Returns:
#	escaped string
function escape() {
	local -r str="${1:-}"
	echo $(echo "${str}" | sed -e 's/[]\/$*.^[]/\\&/g')
}

# ----------------------------------------------------------

function getPlasmoidFileName() {
	local -r pkg_version="$(getMetaTag "X-KDE-PluginInfo-Version")"
	local -r pkg_name="$(getMetaTag "X-KDE-PluginInfo-Name")"
	local -r pkg_base_name=$(echo "${pkg_name}" | awk '{cnt=split($0,a,"."); print a[cnt]}')
	echo "${pkg_base_name}-${pkg_version}.plasmoid"
}

# ----------------------------------------------------------

if [[ -z "${ROOT_DIR}" ]]; then
	echo "*** ROOT_DIR nie jest zdefiniowany albo jest pusty"
	exit 1
fi

#declare -r PLASMOID_FILE_NAME="$(getPlasmoidFileName)"
#echo "  OUTPUT_FILE: ${PLASMOID_FILE_NAME}"

