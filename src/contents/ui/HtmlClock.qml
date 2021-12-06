/**
 * HTML Clock Plasmoid
 *
 * Configurable HTML styled clock plasmoid.
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2021 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import "../js/DateTimeFormatter.js" as DTF
import "../js/layouts.js" as Layouts

ColumnLayout {
	id: mainContainer

	// ------------------------------------------------------------------------------------------------------------------------

	property string layoutKey: plasmoid.configuration.layoutKey
	property bool useUserLayout: plasmoid.configuration.useUserLayout
	property bool useCustomFont: plasmoid.configuration.useCustomFont
	property font customFont: plasmoid.configuration.customFont

	// ------------------------------------------------------------------------------------------------------------------------

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		onClicked: {
			if (plasmoid.configuration.calendarViewEnabled) {
				plasmoid.expanded = !plasmoid.expanded
			}
		}
	}

	// ------------------------------------------------------------------------------------------------------------------------

	PlasmaComponents.Label {
		id: clock
		Layout.alignment: Qt.AlignHCenter
		textFormat: Text.RichText


		font.family: useCustomFont ? customFont.family : theme.defaultFont.family
		font.pointSize: useCustomFont ? customFont.pointSize : theme.defaultFont.pointSize
		font.bold: useCustomFont ? customFont.bold : theme.defaultFont.bold
		font.italic: useCustomFont ? customFont.italic : theme.defaultFont.italic
		font.underline: useCustomFont ? customFont.underline : theme.defaultFont.underline
	}

	PlasmaCore.DataSource {
		engine: "time"
		connectedSources: ["Local"]
		interval: 1000
		intervalAlignment: PlasmaCore.Types.NoAlignment
		onDataChanged: updateClock()
	}

	readonly property string layout: plasmoid.configuration.layout
	property string configTimezoneOffset: plasmoid.configuration.clockTimezoneOffset
	onLayoutChanged: updateClock()

	function updateClock() {
		var layoutHtml = useUserLayout 
				? plasmoid.configuration.layout
				: Layouts.layouts[layoutKey]['html']
		var localeToUse = plasmoid.configuration.useSpecificLocaleEnabled
				? plasmoid.configuration.useSpecificLocaleLocaleName 
				: ''

		var tzOffsetHours = 0
		var tzOffsetMinutes = 0
		var tzOffset = null
		if (plasmoid.configuration.clockTimezoneOffsetEnabled == true) {
			tzOffset = 0
			var tzString = plasmoid.configuration.clockTimezoneOffset
			if (tzString != '') {
				var tzSign = 1
				if(tzString.charAt(0) == '-') {
					tzSign = -1
					tzString = tzString.substring(1)
				} else if(tzString.charAt(0) == '+') {
					tzSign = 1
					tzString = tzString.substring(1)
				}

				var segments = tzString.split(':');
				tzOffsetHours = parseInt(segments[0])
				tzOffsetMinutes = parseInt(segments[1])

				tzOffset = (tzOffsetHours * 60 + tzOffsetMinutes) * tzSign
			}
		}
		clock.text = DTF.format(handleFlip(layoutHtml), localeToUse, tzOffset)
	}

	function handleFlip(text) {
		var reg = new RegExp('\{flip(:(.+)){2}\}', 'g')
		var matches = text.match(reg)
		if (matches !== null) {
			var even = (new Date()).getSeconds() % 2
			var valReg = new RegExp('^\{flip:(.+):(.+)\}$', '')
			matches.forEach(function (val, idx) {
				var valMatch = val.match(valReg)
				text = text.replace(val, valMatch[even ? 1 : 2])
			})
		}

		return text
	}

	// ------------------------------------------------------------------------------------------------------------------------

} // mainContainer
