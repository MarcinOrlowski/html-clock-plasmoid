/**
 * DateTimeFormatter - JS helper library
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2026 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/datetimeformatter
 */

/*
** Pads string with leading zeros to ensure returned
** string is at least 'len' characters long. If string
** is longer thatn 'len' is is returned unaltered.
**
** Arguments:
**  str: string to pad
**  len: length to pad to (if str is shorter). Default 2
**  padChar: padding character. Default is '0' (zero)
**
** Returns:
**  Returns padded string.
*/
function pad(str, len, padChar) {
	if (typeof(str) !== "string") str = str.toString()

	if (len === undefined) len = 2

	if (str.length < len) {
		if (padChar === undefined) padChar = '0'
		str = padChar.repeat(len - str.length) + str
	}

	return str
}

/*
** Uppercase first character of string.
**
** Arguments:
**  string: string to uppercase
**
** Returns:
**  Returns string with first character uppercased (if possible).
*/
function ucfirst(string) {
	return (string.length > 1)
			? string.substr(0, 1).toUpperCase() + string.substr(1)
			: string.toUpperCase();
}

// https://stackoverflow.com/a/8619946/1235698
function getDayOfYear(dt) {
	var start = new Date(dt.getFullYear(), 0, 0)
	var diff = (dt - start) + ((start.getTimezoneOffset() - dt.getTimezoneOffset()) * 60 * 1000)
	var oneDay = 1000 * 60 * 60 * 24
	return Math.floor(diff / oneDay)
}

/*
** Returns number of year week.
**
** Arguments:
**  dt: Date object to be used for calculations.
**
** Returns:
**  Number of year week.
*/
function getWeekOfYear(dt) {
	var tdt = new Date(dt.valueOf())
	var dayn = (dt.getDay() + 6) % 7
	tdt.setDate(tdt.getDate() - dayn + 3)
	var firstThursday = tdt.valueOf()
	tdt.setMonth(0, 1)
	if (tdt.getDay() !== 4) {
		tdt.setMonth(0, 1 + ((4 - tdt.getDay()) + 7) % 7)
	}

	return 1 + Math.ceil((firstThursday - tdt) / 604800000)
}

/*
** Parses timezone offset string (e.g. "+05:30", "-03:00") and returns
** offset in minutes.
**
** Arguments:
**  offsetStr: timezone offset string in format [+-]HH:MM
**
** Returns:
**  Offset in minutes (signed integer), or null if invalid format.
*/
function parseTzOffset(offsetStr) {
	var match = offsetStr.match(/^([+-])(\d{2}):(\d{2})$/)
	if (!match) return null
	var sign = match[1] === '+' ? 1 : -1
	var hours = parseInt(match[2], 10)
	var minutes = parseInt(match[3], 10)
	return sign * (hours * 60 + minutes)
}

/*
** Builds placeholder map for a given date and locale.
**
** Arguments:
**  dt: Date object
**  locale: Qt locale object
**
** Returns:
**  Object with placeholder keys and their values.
*/
function buildMap(dt, locale) {
	var map = {}
	map['yyyy'] = Qt.formatDate(dt, 'yyyy')
	map['yy'] = Qt.formatDate(dt, 'yy')
	map['MMM'] = dt.toLocaleDateString(locale, 'MMMM')
	map['MM'] = dt.toLocaleDateString(locale, 'MMM')
	map['M'] = map['MM'].substr(0, 1)
	map['mm'] = Qt.formatDate(dt, 'MM')
	map['m'] = Qt.formatDate(dt, 'M')
	map['DDD'] = dt.toLocaleDateString(locale, 'dddd')
	map['DD'] = dt.toLocaleDateString(locale, 'ddd')
	map['D'] = map['DD'].substr(0, 1)
	map['dd'] = Qt.formatDate(dt, 'dd')
	map['d'] = Qt.formatDate(dt, 'd')
	map['dy'] = getDayOfYear(dt)
	map['dw'] = dt.getDay() + 1
	map['wy'] = getWeekOfYear(dt)
	map['hh'] = pad(dt.getHours())
	map['h'] = dt.getHours()
	map['kk'] = pad(dt.getHours() % 12 || 12)
	map['k'] = dt.getHours() % 12 || 12
	map['ii'] = pad(dt.getMinutes())
	map['i'] = dt.getMinutes()
	map['ss'] = pad(dt.getSeconds())
	map['s'] = dt.getSeconds()
	map['AA'] = Qt.formatTime(dt, 'AP')
	map['A'] = map['AA'].substr(0, 1)
	map['aa'] = map['AA'].toLowerCase()
	map['a'] = map['aa'].substr(0, 1)
	map['Aa'] = map['A'] + map['aa'].substr(-1)
	map['t'] = dt.toLocaleTimeString(locale, 't')
	map['ldl'] = dt.toLocaleDateString(locale, Locale.LongFormat)
	map['lds'] = dt.toLocaleDateString(locale, Locale.ShortFormat)
	map['ltl'] = dt.toLocaleTimeString(locale, Locale.LongFormat)
	map['lts'] = dt.toLocaleTimeString(locale, Locale.ShortFormat)
	map['ldtl'] = dt.toLocaleString(locale, Locale.LongFormat)
	map['ldts'] = dt.toLocaleString(locale, Locale.ShortFormat)
	return map
}

/*
** Applies modifier to value.
**
** Arguments:
**  value: the value to modify
**  modifier: modifier string (U, L, u, 00)
**
** Returns:
**  Modified value as string.
*/
function applyModifier(value, modifier) {
	var str = value.toString()
	switch (modifier) {
		case 'U': return str.toUpperCase()
		case 'L': return str.toLowerCase()
		case 'u': return ucfirst(str)
		case '00': return pad(value, 2)
		default: return str
	}
}

/*
** Processes provied template string, replacing all known placeholders
** with corresponding values.
**
** Arguments:
**     template: string to be processed
**   localeName: (optional) locale name to use (i.e. 'en_US', 'pl_PL').
**               System default will be used if not provided.
**     tzOffset: (optional) timezone offset from GMT in minutes,
**               stored as signed integer
**
** Placeholder syntax:
**   {key} - basic placeholder
**   {key:modifier} or {key|modifier} - with modifier (U, L, u, 00)
**   {key|+HH:MM} or {key|-HH:MM} - with timezone offset (| separator only)
**   {key|+HH:MM|modifier} - timezone + modifier (| separator only)
*/
function format(template, localeName, tzOffset = null) {
	if (localeName === undefined) localeName = ''
	var locale = Qt.locale(localeName)

	var now = new Date()
	if (tzOffset !== null) {
		now = new Date(now.valueOf() + (tzOffset + now.getTimezoneOffset()) * 60 * 1000)
	}

	// Build map for current/offset time
	var map = buildMap(now, locale)
	var keys = Object.keys(map).sort(function(a, b) { return b.length - a.length })

	// Process placeholders with | separator and timezone offset first
	// Pattern: {key|[+-]HH:MM} or {key|[+-]HH:MM|modifier}
	var tzPattern = /\{(\w+)\|([+-]\d{2}:\d{2})(?:\|(\w+))?\}/g
	template = template.replace(tzPattern, function(match, key, tz, modifier) {
		if (!(key in map)) return match
		var tzOffsetMinutes = parseTzOffset(tz)
		if (tzOffsetMinutes === null) return match
		// Calculate time with this specific offset
		var baseNow = new Date()
		var tzNow = new Date(baseNow.valueOf() + (tzOffsetMinutes + baseNow.getTimezoneOffset()) * 60 * 1000)
		var tzMap = buildMap(tzNow, locale)
		var value = tzMap[key]
		if (modifier) {
			value = applyModifier(value, modifier)
		}
		return value
	})

	// Process remaining placeholders with both : and | separators
	for (var i = 0; i < keys.length; i++) {
		var key = keys[i]
		var value = map[key]
		// Basic placeholder
		template = template.replace(new RegExp('\\{' + key + '\\}', 'g'), value)
		// With modifiers (both : and | separators)
		var modifiers = ['U', 'L', 'u', '00']
		for (var j = 0; j < modifiers.length; j++) {
			var mod = modifiers[j]
			var modValue = applyModifier(value, mod)
			template = template.replace(new RegExp('\\{' + key + ':' + mod + '\\}', 'g'), modValue)
			template = template.replace(new RegExp('\\{' + key + '\\|' + mod + '\\}', 'g'), modValue)
		}
	}

	return template
}
