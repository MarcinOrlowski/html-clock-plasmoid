/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2026 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support
import "../js/DateTimeFormatter.js" as DTF
import "../js/layouts.js" as Layouts
import "../js/utils.js" as Utils

ColumnLayout {
	id: mainContainer

	// Signal to notify parent to toggle expanded state
	signal toggleExpanded()

	// ------------------------------------------------------------------------------------------------------------------------

	property string layoutKey: Plasmoid.configuration.layoutKey
	property bool useUserLayout: Plasmoid.configuration.useUserLayout
	property bool useCustomFont: Plasmoid.configuration.useCustomFont
	property font customFont: Plasmoid.configuration.customFont
	property bool widgetContainerFillWidth: Plasmoid.configuration.widgetContainerFillWidth
	property bool widgetContainerFillHeight: Plasmoid.configuration.widgetContainerFillHeight

	// ------------------------------------------------------------------------------------------------------------------------

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		onClicked: {
			if (Plasmoid.configuration.calendarViewEnabled) {
				mainContainer.toggleExpanded()
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

		font.family: useCustomFont ? customFont.family : Qt.application.font.family
		font.pointSize: useCustomFont ? customFont.pointSize : Qt.application.font.pointSize
		font.bold: useCustomFont ? customFont.bold : Qt.application.font.bold
		font.italic: useCustomFont ? customFont.italic : Qt.application.font.italic
		font.underline: useCustomFont ? customFont.underline : Qt.application.font.underline
	}

	Plasma5Support.DataSource {
		engine: "time"
		connectedSources: ["Local", "UTC"]
		interval: 1000
		intervalAlignment: Plasma5Support.Types.NoAlignment
		onDataChanged: updateClock()
	}

	readonly property string layout: Plasmoid.configuration.layout
	property string configTimezoneOffset: Plasmoid.configuration.clockTimezoneOffset
	onLayoutChanged: updateClock()

	function updateClock() {
		var layoutHtml = useUserLayout
				? Plasmoid.configuration.layout
				: Layouts.layouts[layoutKey]['html']
		var localeToUse = Plasmoid.configuration.useSpecificLocaleEnabled
				? Plasmoid.configuration.useSpecificLocaleLocaleName
				: ''
		var finalOffsetOrNull = Plasmoid.configuration.clockTimezoneOffsetEnabled
			? Utils.parseTimezoneOffset(Plasmoid.configuration.clockTimezoneOffset)
			: null
		clock.text = DTF.format(handleFlip(layoutHtml), localeToUse, finalOffsetOrNull)
	}

	function handleFlip(text) {
		var reg = new RegExp('\{flip:(.+?):(.+?)\}', 'gi')
		var matches = text.match(reg)
		if (matches !== null) {
			var even = (new Date()).getSeconds() % 2
			var valReg = new RegExp('^\{flip:(.+?):(.+?)\}$', 'i')
			matches.forEach(function (val, idx) {
				var valMatch = val.match(valReg)
				text = text.replace(val, valMatch[even ? 1 : 2])
				// console.log(`XXXXX val: ${val}, 1: ${valMatch[1]}, 2: ${valMatch[2]}`)
			})
		}

		return text
	}

	// ------------------------------------------------------------------------------------------------------------------------

} // mainContainer
