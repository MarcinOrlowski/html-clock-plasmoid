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

# shellcheck shell=bash  # sourced, not executed (no shebang by design)
set -euo pipefail

# Reads given jq path from Plasma 6 metadata.json.
# If the value is missing or empty, returns ${default} (empty string if not provided).
#
# Arguments:
#       path: jq path expression, e.g. '.KPlugin.Version'
#    default: value to return when the path is absent or empty
#
function jsonGet() {
	local -r _path="${1}"
	local -r _default="${2:-}"

	local _result
	_result="$(jq -r "${_path} // empty" < "${PLASMOID_ROOT}/metadata.json" 2>/dev/null)"
	if [[ -z "${_result}" ]]; then
		_result="${_default}"
	fi

	printf '%s' "${_result}"
}

# ==============================================================================

# Echos data from metadata.json file as JS code.
# This works around QML not exposing all metadata fields at runtime.
#
# Standard fields live under KPlugin. Fields with no KPlugin equivalent
# (author URL, update checker URL, first release year) are stored as
# custom top-level X-MHL-* keys in metadata.json.
#
function dumpMeta() {
	local -r _version="$(jsonGet '.KPlugin.Version')"
	local -r _title="$(jsonGet '.KPlugin.Name')"
	local -r _url="$(jsonGet '.KPlugin.Website')"
	local -r _author_name="$(jsonGet '.KPlugin.Authors[0].Name')"
	local -r _author_url="$(jsonGet '."X-MHL-Author-Url"')"
	local -r _update_checker_url="$(jsonGet '."X-MHL-UpdateChecker-Url"')"
	local -r _first_release_year="$(jsonGet '."X-MHL-FirstReleaseYear"' 1980)"

	# shellcheck disable=SC2140  # adjacent quoted strings concatenate intentionally
	echo -e \
"// This file is auto-generated. DO NOT EDIT BY HAND\n"\
"// Generated: $(date --iso-8601=seconds)\n"\
"\n"\
"// https://doc.qt.io/qt-6/qtqml-javascript-resources.html\n"\
".pragma library\n"\
"\n"\
"const version=\"${_version}\"\n"\
"const title=\"${_title}\"\n"\
"const url=\"${_url}\"\n"\
"const authorName=\"${_author_name}\"\n"\
"const authorUrl=\"${_author_url}\"\n"\
"const updateCheckerUrl=\"${_update_checker_url}\"\n"\
"const firstReleaseYear=${_first_release_year}\n"
}

# ==============================================================================

# Looks for a plasmoid valid root folder. Starts from ${_dir}
# then goes up until root folder is reached.
#
# Note: by convention used, it first looks for "src/" folder
# in given folder, then checks if it contains metadata.json
# file. If it does, this is our valid root folder.
#
# Arguments:
#  dir: path to start from. Usually $(pwd)
#
function findAppletSrcDir() {
	local _dir="${1}"

	local _result=""
	while [[ -z "${_result}" && "${_dir}" != "/" ]]; do
		if [[ -d "${_dir}/src" ]]; then
			if [[ -f "${_dir}/src/metadata.json" ]]; then
				_result="$(realpath "${_dir}/src")"
			fi
		fi

		if [[ -z "${_result}" ]]; then
			_dir="$(dirname "${_dir}")"
		fi
	done

	echo "${_result}"
}

# ==============================================================================

if [[ -z "${ROOT_DIR}" ]]; then
	echo "*** ROOT_DIR must be declared and cannot be empty."
	exit 1
fi

PLASMOID_ROOT="$(findAppletSrcDir "$(pwd)")"
declare -r PLASMOID_ROOT
if [[ -z "${PLASMOID_ROOT}" ]]; then
	echo "*** Unable to locate applet source dir from $(pwd)"
	exit 1
fi

# ==============================================================================

# Check for required dependencies
if ! command -v jq &> /dev/null; then
	echo "*** jq is required but not installed. Install with: sudo apt install jq"
	exit 1
fi

# ==============================================================================

# Shows given error message and then terminates script execution with exit
# code 1.
#
# Arguments:
#	      msg: Optional message string to show. Default "Aborted"
#
function abort {
	echo -e "${ERROR}*** ${1:-Aborted.}"
	exit 1
}
