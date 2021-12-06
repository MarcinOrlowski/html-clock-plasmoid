// https://doc.qt.io/qt-5/qtqml-javascript-resources.html
.pragma library

const defaultLayout='__default__'

// Use backticks for multiline strings.
const layouts = {
	'__default__': {
		"name": "Default",
		"html":	'<html>' + "\n" +
				'<body>' + "\n" +
				'<center>' + "\n" +
				'	<span style="font-size: 35px; font-weight: bold; color: #ff006e;">{hh}</span>' + "\n" +
				'	<span style="font-size: 25px; font-weight: bold; color: #{flip:00:FF}79808d;">:</span>' + "\n" +
				'	<span style="font-size: 30px; color: white;">{ii}</span>' + "\n" +
				'</center>' + "\n" +
				'</body>' + "\n" +
				'</html>'
	},

	'time-seconds-sup': {
		"name": "Time w/seconds",
		"html":	'<html>' + "\n" +
				'<body>' + "\n" +
				'<center>' + "\n" +
				'<span style="font-size: 35px; font-weight: bold; color: #ff006e;">{hh}</span>' + "\n" +
				'<span style="font-size: 25px; color: #79808d;">:</span>' + "\n" +
				'<span style="font-size: 30px; color: white;">{ii}<span style="font-size: 20px; color: #cccccc;"><sup>{ss}</sup></span></span>' + "\n" +
				'</center>' + "\n" +
				'</body>' + "\n" +
				'</html>'
	},

	'date-time-seconds-sup-vertical': {
		"name": "Date&Time w/seconds (vertical)",
		"html":	'<html>' + "\n" +
				'<body>' + "\n" +
				'<center>' + "\n" +
				'<span style="font-size: 35px; font-weight: bold; color: #ff006e;">{hh}</span>' + "\n" +
				'<span style="font-size: 25px; color: #79808d;">:</span>' + "\n" +
				'<span style="font-size: 30px; color: white;">{ii}<span style="font-size: 20px; color: #cccccc;"><sup>{ss}</sup></span></span>' + "\n" +
				'<br />' + "\n" +
				'<span style="font-size: 15px;">{yyyy}-{MM:U}-{dd}</span>' + "\n" +
				'</center>' +
				'</body>' + "\n" +
				'</html>'
	},

	'date-time-grid': {
		"name": "Date&Time grid",
		"html":	'<html>' + "\n" +
				'<body>' + "\n" +
				'<table style="border: none;" align="center">' + "\n" +
				'<tr>' + "\n" +
				'  <td valign="middle">' + "\n" +
				'    <span style="font-size: 40px; font-weight: bold; color: #FFff006e;">{hh}</span>' + "\n" +
				'    <span style="font-size: 35px; font-weight: bold; color: #{flip:00:FF}ff006e;">:</span>' + "\n" +
				'    <span style="font-size: 40px; color: white;">{ii}</span>' + "\n" +
				'  </td>' + "\n" +
				'  <td width="1" style="vertical-align: middle; background-color: #FFff006e; padding-right: 0px;"><br />&nbsp;<br /></td>' + "\n" +
				'  <td>' + "\n" +
				'    <table style="border: none;">' + "\n" +
				'      <tr><td align="center"><span style="font-size: 15px; font-weight: bold; color: white;">{DD:U}</span></td></tr>' + "\n" +
				'      <tr><td align="center"><span style="font-size: 10px; color: white;">{dd}</span></td></tr>' + "\n" +
				'      <tr><td align="center"><span style="font-size: 10px; color: white;">{MM:U}</span></td></tr>' + "\n" +
				'    </table>' + "\n" +
				'  </td>' + "\n" +
				'</tr>' + "\n" +
				'</table>' +
				'</body>' + "\n" +
				'</html>'
	},

	'date-time-grid-big': {
		"name": "Date&Time grid big",
		"html":	'<html>' + "\n" +
				'<body>' + "\n" +
				'<table style="border: none;" align="center">' + "\n" +
				'<tr>' + "\n" +
				'  <td valign="middle">' + "\n" +
				'    <table>' + "\n" +
				'    <tr>' + "\n" +
				'      <td valign="middle" align="center">' + "\n" +
				'        <span style="font-size: 40px; font-weight: bold; color: #FFff006e;">{hh}</span>' + "\n" +
				'        <span style="font-size: 35px; font-weight: bold; color: #{flip:00:FF}ff006e;">:</span>' + "\n" +
				'        <span style="font-size: 40px; color: white;">{ii}</span>' + "\n" +
				'      </td>' + "\n" +
				'    <tr>' + "\n" +
				'    <tr>' + "\n" +
				'      <td valign="middle" align="center">' + "\n" +
				'        <tr><td align="center"><span style="font-size: 15px; font-weight: bold; color: white;">{DDD:U}</span></td></tr>' + "\n" +
				'      </td>' + "\n" +
				'    <tr>' + "\n" +
				'    </table>' + "\n" +
				'  </td>' + "\n" +
				'  <td width="1" style="vertical-align: middle; background-color: #FFff006e; padding-right: 0px;"><br />&nbsp;<br /></td>' + "\n" +
				'  <td>' + "\n" +
				'    <table style="border: none;">' + "\n" +
				'      <tr><td align="center"><span style="font-size: 15px; font-weight: bold; color: white;">{DD:U}</span></td></tr>' + "\n" +
				'      <tr><td align="center"><span style="font-size: 10px; color: white;">{dd}</span></td></tr>' + "\n" +
				'      <tr><td align="center"><span style="font-size: 10px; color: white;">{MM:U}</span></td></tr>' + "\n" +
				'    </table>' + "\n" +
				'  </td>' + "\n" +
				'</tr>' + "\n" +
				'</table>' + "\n" +
				'</body>' + "\n" +
				'</html>'
	},

	'date-time-grid-with-day': {
		"name": "Date&Time grid w/dayname",
		"html":	'<html>' + "\n" +
				'<body>' + "\n" +
				'<table style="border: none;" align="center">' + "\n" +
				'    <tr>' + "\n" +
				'        <!-- clock -->' + "\n" +
				'        <td valign="middle" align="center" style="padding-right: 4px;">' + "\n" +
				'            <span style="font-size: 40px; font-weight: bold; color: #FFff006e;">{hh}</span>' + "\n" +
				'            <span style="font-size: 35px; font-weight: bold; color: #{flip:00:FF}ff006e;">:</span>' + "\n" +
				'            <span style="font-size: 40px; color: white;">{ii}</span>' + "\n" +
				'        </td>' + "\n" +
				'        <!-- verical divider -->' + "\n" +
				'        <td rowspan="2" width="1" style="vertical-align: middle; background-color: #FFff006e;">' + "\n" +
				'            <span style="font-size: 25px;"><br /><br /></span>' + "\n" +
				'        </td>' + "\n" +
				'        <!-- calendar -->' + "\n" +
				'        <td rowspan="2" valign="middle" align="center" style="padding-left: 4px;">' + "\n" +
				'            <span style="font-size: 15px; font-weight: bold; color: white;">{dd}<br />{MM:U}<br />{yyyy}</span>' + "\n" +
				'        <td>' + "\n" +
				'    </tr>' + "\n" +
				'    <tr>' + "\n" +
				'        <!-- weekday name -->' + "\n" +
				'        <td valign="middle" align="center" style="padding-right: 4px;">' + "\n" +
				'            <span style="font-size: 15px; font-weight: bold; color: white;">{DDD:U}</span>' + "\n" +
				'        </td>' + "\n" +
				'    </tr>' + "\n" +
				'</table>' + "\n" +
				'</body>' + "\n" +
				'</html>'
	},

	'date-time-vertical': {
		"name": "Date&Time (vertical)",
		"html":	'<html>' + "\n" +
				'<body>' + "\n" +
				'<center>' + "\n" +
				'	<span style="font-size: 35px; font-weight: bold; color: #ff006e;">{hh}</span>' + "\n" +
				'	<span style="font-size: 25px; font-weight: bold; color: #{flip:00:FF}ff006e;">:</span>' + "\n" +
				'	<span style="font-size: 30px; color: white;">{ii}</span>' + "\n" +
				'	<br />' + "\n" +
				'	<span style="font-size: 15px;">{yyyy}-{MM:U}-{dd}</span>' + "\n" +
				'</center>' + "\n" +
				'</body>' + "\n" +
				'</html>'
	},

	'system-time-short': {
		"name": "System time format (short)",
		"html":	'<html>' + "\n" +
				'<body>' + "\n" +
				'<center>' + "\n" +
				'{lts}' + "\n" +
				'</center>' + "\n" +
				'</body>' + "\n" +
				'</html>'
	},

	'system-time-long': {
		"name": "System time format (long)",
		"fontPixelSize": 1,
		"html":	'<html>' + "\n" +
				'<body>' + "\n" +
				'<center>' + "\n" +
				'{ltl}' + "\n" +
				'</center>' + "\n" +
				'</body>' + "\n" +
				'</html>'
	}

}

