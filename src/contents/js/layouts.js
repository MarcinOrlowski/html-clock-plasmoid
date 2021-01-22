var defaultLayout='__default__'

// Use backticks for multiline strings.
var layouts = {
	'__default__': {
		"name": "Default",
		"fontPixelSize": 20,
		"html": `
<center> 
<span style="font-size: 35px; font-weight: bold; color: #ff006e;">{hh}</span>
<span style="font-size: 25px; color: #79808d;">:</span>
<span style="font-size: 30px; color: white;">{ii}</span>
</center>
`},

	'time-seconds-sup': {
		"name": "Time with small seconds",
		"fontPixelSize": 20,
		"html": `
<center> 
<span style="font-size: 35px; font-weight: bold; color: #ff006e;">{hh}</span>
<span style="font-size: 25px; color: #79808d;">:</span>
<span style="font-size: 30px; color: white;">{ii}<span style="font-size: 20px; color: #cccccc;"><sup>{ss}</sup></span></span>
<br />
<span style="font-size: 15px;">{yyyy}-{MM:U}-{dd}</span>
</center>
`},

	'date-time-vertical': {
		"name": "Date&Time (vertical)",
		"fontPixelSize": 20,
		"html": `
<center> 
<span style="font-size: 35px; font-weight: bold; color: #ff006e;">{hh}</span>
<span style="font-size: 25px; color: #79808d;">:</span>
<span style="font-size: 30px; color: white;">{ii}</span>
<br />
<span style="font-size: 15px;">{yyyy}-{MM:U}-{dd}</span>
</center>
`},

	'system-time-short': {
		"name": "System time format (short)",
		"fontPixelSize": 20,
		"html": `
<center>
{lts}
</center>
`},

	'system-time-long': {
		"name": "System time format (long)",
		"fontPixelSize": 20,
		"html": `
<center>
{ltl}
</center>
`}

}

