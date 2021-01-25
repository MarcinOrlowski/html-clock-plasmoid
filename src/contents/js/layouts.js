var defaultLayout='__default__'

// Use backticks for multiline strings.
var layouts = {
	'__default__': {
		"name": "Default",
		"fontPixelSize": 20,
		"html": `
<center> 
<span style="font-size: 35px; font-weight: bold; color: #ff006e;">{hh}</span>
<span style="font-size: 25px; font-weight: bold; color: #{flip:00:FF}79808d;">:</span>
<span style="font-size: 30px; color: white;">{ii}</span>
</center>
`},

	'time-seconds-sup': {
		"name": "Time w/seconds",
		"fontPixelSize": 1,
		"html": `
<center> 
<span style="font-size: 35px; font-weight: bold; color: #ff006e;">{hh}</span>
<span style="font-size: 25px; color: #79808d;">:</span>
<span style="font-size: 30px; color: white;">{ii}<span style="font-size: 20px; color: #cccccc;"><sup>{ss}</sup></span></span>
</center>
`},

	'date-time-seconds-sup-vertical': {
		"name": "Date&Time w/seconds (vertical)",
		"fontPixelSize": 1,
		"html": `
<center> 
<span style="font-size: 35px; font-weight: bold; color: #ff006e;">{hh}</span>
<span style="font-size: 25px; color: #79808d;">:</span>
<span style="font-size: 30px; color: white;">{ii}<span style="font-size: 20px; color: #cccccc;"><sup>{ss}</sup></span></span>
<br />
<span style="font-size: 15px;">{yyyy}-{MM:U}-{dd}</span>
</center>
`},

	'date-time-grid': {
		"name": "Date&Time grid",
		"fontPixelSize": 10,
		"html": `
<table style="border: none;" align="center">
<tr>
  <td valign="middle">
    <span style="font-size: 40px; font-weight: bold; color: #FFff006e;">{hh}</span>
    <span style="font-size: 35px; font-weight: bold; color: #{flip:00:FF}ff006e;">:</span>
    <span style="font-size: 40px; color: white;">{ii}</span>
  </td>
  <td width="1" style="vertical-align: middle; background-color: #FFff006e; padding-right: 0px;"><br />&nbsp;<br /></td>
  <td>
    <table style="border: none;">
      <tr><td align="center"><span style="font-size: 15px; font-weight: bold; color: white;">{DD:U}</span></td></tr>
      <tr><td align="center"><span style="font-size: 10px; color: white;">{dd}</span></td></tr>
      <tr><td align="center"><span style="font-size: 10px; color: white;">{MM:U}</span></td></tr>
    </table>
  </td>
</tr>
</table>
`},

	'date-time-grid-big': {
		"name": "Date&Time grid big",
		"fontPixelSize": 10,
		"html": `
<table style="border: none;" align="center">
<tr>
  <td valign="middle">
    <table>
    <tr>
      <td valign="middle" align="center>>
        <span style="font-size: 40px; font-weight: bold; color: #FFff006e;">{hh}</span>
        <span style="font-size: 35px; font-weight: bold; color: #{flip:00:FF}ff006e;">:</span>
        <span style="font-size: 40px; color: white;">{ii}</span>
      </td>
    <tr>
    <tr>
      <td valign="middle" align="center>>
        <tr><td align="center"><span style="font-size: 15px; font-weight: bold; color: white;">{DDD:U}</span></td></tr>
      </td>
    <tr>
    </table>
  </td>
  <td width="1" style="vertical-align: middle; background-color: #FFff006e; padding-right: 0px;"><br />&nbsp;<br /></td>
  <td>
    <table style="border: none;">
      <tr><td align="center"><span style="font-size: 15px; font-weight: bold; color: white;">{DD:U}</span></td></tr>
      <tr><td align="center"><span style="font-size: 10px; color: white;">{dd}</span></td></tr>
      <tr><td align="center"><span style="font-size: 10px; color: white;">{MM:U}</span></td></tr>
    </table>
  </td>
</tr>
</table>
`},

	'date-time-grid-with-day': {
		"name": "Date&Time grid w/dayname",
		"fontPixelSize": 1,
		"html": `
<table style="border: none;" align="center">
    <tr>
        <!-- clock -->
        <td valign="middle" align="center" style="padding-right: 4px;">
            <span style="font-size: 40px; font-weight: bold; color: #FFff006e;">{hh}</span>
            <span style="font-size: 35px; font-weight: bold; color: #{flip:00:FF}ff006e;">:</span>
            <span style="font-size: 40px; color: white;">{ii}</span>
        </td>
        <!-- verical divider -->
        <td rowspan="2" width="1" style="vertical-align: middle; background-color: #FFff006e;">
            <span style="font-size: 25px;"><br /><br /></span>
        </td>
        <!-- calendar -->
        <td rowspan="2" valign="middle" align="center" style="padding-left: 4px;">
            <span style="font-size: 15px; font-weight: bold; color: white;">{dd}<br />{MM:U}<br />{yyyy}</span>
        <td>
    </tr>
    <tr>
        <!-- weekday name -->
        <td valign="middle" align="center" style="padding-right: 4px;">
            <span style="font-size: 15px; font-weight: bold; color: white;">{DDD:U}</span>
        </td>
    </tr>
</table>
`},

	'date-time-vertical': {
		"name": "Date&Time (vertical)",
		"fontPixelSize": 1,
		"html": `
<center> 
<span style="font-size: 35px; font-weight: bold; color: #ff006e;">{hh}</span>
<span style="font-size: 25px; font-weight: bold; color: #{flip:00:FF}ff006e;">:</span>
<span style="font-size: 30px; color: white;">{ii}</span>
<br />
<span style="font-size: 15px;">{yyyy}-{MM:U}-{dd}</span>
</center>
`},

	'system-time-short': {
		"name": "System time format (short)",
		"fontPixelSize": 1,
		"html": `
<center>
{lts}
</center>
`},

	'system-time-long': {
		"name": "System time format (long)",
		"fontPixelSize": 1,
		"html": `
<center>
{ltl}
</center>
`}


}

