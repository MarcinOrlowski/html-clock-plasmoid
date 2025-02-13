/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2023 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import "../js/DateTimeFormatter.js" as DTF
import "../js/layouts.js" as Layouts
import "../js/utils.js" as Utils

ColumnLayout {
	id: mainContainer
	spacing: 0

	Layout.fillWidth: widgetContainerFillWidth
	Layout.fillHeight: widgetContainerFillHeight
	Layout.minimumWidth: mouseArea.implicitWidth
	Layout.minimumHeight: mouseArea.implicitHeight
	Layout.preferredWidth: mouseArea.implicitWidth
	Layout.preferredHeight: mouseArea.implicitHeight
	Layout.alignment: Qt.AlignCenter

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
		Layout.fillWidth: true
		Layout.fillHeight: true
		Layout.alignment: Qt.AlignCenter
		implicitWidth: clock.implicitWidth + Kirigami.Units.largeSpacing * 2
		implicitHeight: clock.implicitHeight + Kirigami.Units.largeSpacing * 2

		onClicked: {
			if (plasmoid.configuration.calendarViewEnabled) {
				expanded = !expanded
			}
		}

		PlasmaComponents.Label {
			id: clock
			anchors.centerIn: parent
			textFormat: Text.RichText
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			width: implicitWidth
			height: implicitHeight

			font.family: useCustomFont ? customFont.family : Kirigami.Theme.defaultFont.family
			font.pointSize: useCustomFont ? customFont.pointSize : Kirigami.Theme.defaultFont.pointSize
			font.bold: useCustomFont ? customFont.bold : Kirigami.Theme.defaultFont.bold
			font.italic: useCustomFont ? customFont.italic : Kirigami.Theme.defaultFont.italic
			font.underline: useCustomFont ? customFont.underline : Kirigami.Theme.defaultFont.underline
		}
	}

	Plasma5Support.DataSource {
		engine: "time"
		connectedSources: ["Local", "UTC"]
		interval: 1000
		intervalAlignment: Plasma5Support.Types.NoAlignment
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
