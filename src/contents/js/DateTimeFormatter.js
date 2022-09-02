/**
 * DateTimeFormatter - JS helper library
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2022 Marcin Orlowski
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
** Processes provied template string, replacing all known placeholders
** with corresponding values.
**
** Arguments:
**     template: string to be processed
**   localeName: (optional) locale name to use (i.e. 'en_US', 'pl_PL').
**               System default will be used if not provided.
**     tzOffset: (optional) timezone offset from GMT in minutes,
**               stored as signed integer
*/
function format(template, localeName, tzOffset = null) {
	if (localeName === undefined) localeName = ''
	var locale = Qt.locale(localeName)

	var now = new Date()

	if (tzOffset !== null) {
		// if offset is set, we need to calc the date relative to UTC
		var offsetInMillis = tzOffset * 60 * 1000
		now = new Date(now.valueOf() + offsetInMillis)
	}

	var map = {}
	// https://doc.qt.io/qt-5/qml-qtqml-qt.html#formatDateTime-method
	map['yyyy'] = Qt.formatDate(now, 'yyyy')
	map['yy'] = Qt.formatDate(now, 'yy')
	map['MMM'] = now.toLocaleDateString(locale, 'MMMM')
	map['MM'] = now.toLocaleDateString(locale, 'MMM')
	map['M'] = map['MM'].substr(0, 1)
	map['mm'] = Qt.formatDate(now, 'MM')
	map['m'] = Qt.formatDate(now, 'M')
	map['DDD'] = now.toLocaleDateString(locale, 'dddd')
	map['DD'] = now.toLocaleDateString(locale, 'ddd')
	map['D'] = map['DD'].substr(0, 1)
	map['dd'] = Qt.formatDate(now, 'dd')
	map['d'] = Qt.formatDate(now, 'd')
	map['dy'] = getDayOfYear(now)

	// FIXME: add support for any day being first day of the week for all d* fields (for now it's Sunday)
	map['dw'] = now.getDay()+1
//	wm
	map['wy'] = getWeekOfYear(now)
	map['hh'] = pad(now.getHours())
	map['h'] = now.getHours()
	map['kk'] = pad(now.getHours()%12 || 12)
	map['k'] = now.getHours()%12 || 12
	map['ii'] = pad(now.getMinutes())
	map['i'] = now.getMinutes()
	map['ss'] = pad(now.getSeconds())
	map['s'] = now.getSeconds()

	// am/pm
	map['AA'] = Qt.formatTime(now, 'AP')
	map['A'] = map['AA'].substr(0, 1)
	map['aa'] = map['AA'].toLowerCase()
	map['a'] = map['aa'].substr(0, 1)
	map['Aa'] = map['A'] + map['aa'].substr(-1)

	// name of current timezone
	map['t'] = now.toLocaleTimeString(locale, 't')

	// date long/short
	map['ldl'] = now.toLocaleDateString(locale, Locale.LongFormat)
	map['lds'] = now.toLocaleDateString(locale, Locale.ShortFormat)
	// time long/short
	map['ltl'] = now.toLocaleTimeString(locale, Locale.LongFormat)
	map['lts'] = now.toLocaleTimeString(locale, Locale.ShortFormat)
	// date, time long/short
	map['ldtl'] = now.toLocaleString(locale, Locale.LongFormat)
	map['ldts'] = now.toLocaleString(locale, Locale.ShortFormat)

	for(var key in map) {
		template = template.replace(new RegExp('{'+key+'}', 'g'), map[key])
		template = template.replace(new RegExp('{'+key+':U}', 'g'), map[key].toString().toUpperCase())
		template = template.replace(new RegExp('{'+key+':L}', 'g'), map[key].toString().toLowerCase())
		template = template.replace(new RegExp('{'+key+':u}', 'g'), ucfirst(map[key].toString()))
		template = template.replace(new RegExp('{'+key+':00}', 'g'), pad(map[key], 2))
	}

	return template
}

