// https://doc.qt.io/qt-5/qtqml-javascript-resources.html
.pragma library

/**
 * Parses tzString (in format [+-]hh:mm) and returns the number of offset
 * minutes from UTC. Offset not following expected format falls back to 0 (GMT).
 *
 * @param string offsetString
 * @returns int signed. TZ offset in minutes (from UTC)
 */
function parseTimezoneOffset(offsetString) {
	if (!offsetString) return 0

	var tzSign = 1
	var tzString = offsetString
	if(tzString.charAt(0) == '-') {
		tzSign = -1
		tzString = tzString.substring(1)
	} else if(tzString.charAt(0) == '+') {
		tzSign = 1
		tzString = tzString.substring(1)
	}

	var offset = 0
	var segments = tzString.split(':');
	if (segments.length == 2) {
		var hours = parseInt(segments[0])
		var minutes = parseInt(segments[1])
		if (!isNaN(hours) && !isNaN(minutes)) {
			offset = (hours * 60 + minutes) * tzSign
		}
	}

	return offset
}

/**
 * Returns name of the locale the clock is to be formatted with. Empty
 * string means system locale is to be used.
 *
 * @param object config Plasmoid.configuration object
 * @returns string locale name (i.e. 'pl_PL') or empty string
 */
function configuredLocale(config) {
	return config.useSpecificLocaleEnabled ? config.useSpecificLocaleLocaleName : ''
}

/**
 * Returns number of milliseconds left till the next full second, to be used as
 * interval of a self-correcting Timer. A Timer with a fixed 1000ms interval keeps
 * whatever phase it was started with, so the clock would update up to a second
 * off the real second boundary. Result is never lower than 10ms, so a trigger
 * fired a hair too early cannot turn into a busy loop.
 *
 * @returns int milliseconds till the next full second
 */
function msToNextSecond() {
	return Math.max(10, 1000 - (new Date()).getMilliseconds())
}

/**
 * Returns timezone offset the clock is to be formatted with, or null
 * when local time is to be used.
 *
 * @param object config Plasmoid.configuration object
 * @returns int|null signed TZ offset in minutes (from UTC), or null
 */
function configuredTzOffset(config) {
	return config.clockTimezoneOffsetEnabled ? parseTimezoneOffset(config.clockTimezoneOffset) : null
}
