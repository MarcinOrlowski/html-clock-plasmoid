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
import "../js/utils.js" as Utils

ColumnLayout {
	id: mainContainer

	// ------------------------------------------------------------------------------------------------------------------------

	property string layoutKey: plasmoid.configuration.layoutKey
	property bool useUserLayout: plasmoid.configuration.useUserLayout
	property bool useCustomFont: plasmoid.configuration.useCustomFont
	property font customFont: plasmoid.configuration.customFont
	property bool widgetContainerFillWidth: plasmoid.configuration.widgetContainerFillWidth
	property bool widgetContainerFillHeight: plasmoid.configuration.widgetContainerFillHeight

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
		Layout.fillWidth: widgetContainerFillWidth
		Layout.fillHeight: widgetContainerFillHeight

		font.family: useCustomFont ? customFont.family : theme.defaultFont.family
		font.pointSize: useCustomFont ? customFont.pointSize : theme.defaultFont.pointSize
		font.bold: useCustomFont ? customFont.bold : theme.defaultFont.bold
		font.italic: useCustomFont ? customFont.italic : theme.defaultFont.italic
		font.underline: useCustomFont ? customFont.underline : theme.defaultFont.underline
	}

	PlasmaCore.DataSource {
		engine: "time"
		connectedSources: ["Local", "UTC"]
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
		var finalOffsetOrNull = plasmoid.configuration.clockTimezoneOffsetEnabled
			? Utils.parseTimezoneOffset(plasmoid.configuration.clockTimezoneOffset)
			: null
		clock.text = DTF.format(handleFlip(layoutHtml), localeToUse, finalOffsetOrNull)
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
