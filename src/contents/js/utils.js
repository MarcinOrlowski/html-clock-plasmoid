// https://doc.qt.io/qt-5/qtqml-javascript-resources.html
.pragma library

/**
 * Parses tzString (in format [+-]hh:mm) and returns the number of 
 * offset minutes from UTC. May return garbage for uzString not
 * following expected format)
 * 
 * @param string offsetString
 * @returns int signed. TZ offset in minutes (from UTC)
 */
function parseTimezoneOffset(offsetString) {
	var tzSign = 1
	var tzString = offsetString
	if(tzString.charAt(0) == '-') {
		tzSign = -1
		tzString = tzString.substring(1)
	} else if(tzString.charAt(0) == '+') {
		tzSign = 1
		tzString = tzString.substring(1)
	}

	var segments = tzString.split(':');
	if (segments.length == 2) {
		var hours = parseInt(segments[0])
		var minutes = parseInt(segments[1])
		var offset = (hours * 60 + minutes) * tzSign
	}

	return offset
}