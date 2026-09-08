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
import "../js/placeholders.js" as Placeholders
import "../js/utils.js" as Utils

ColumnLayout {
	id: mainContainer
	spacing: 0

	// Signal to notify parent to toggle expanded state
	signal toggleExpanded()

	// ------------------------------------------------------------------------------------------------------------------------

	property string layoutKey: Plasmoid.configuration.layoutKey
	property bool useUserLayout: Plasmoid.configuration.useUserLayout
	property int activeLayoutSlot: Plasmoid.configuration.activeLayoutSlot
	property bool useCustomFont: Plasmoid.configuration.useCustomFont
	property font customFont: Plasmoid.configuration.customFont
	property bool widgetContainerFillWidth: Plasmoid.configuration.widgetContainerFillWidth
	property bool widgetContainerFillHeight: Plasmoid.configuration.widgetContainerFillHeight
	property int flipInterval: Plasmoid.configuration.flipInterval
	property int cycleIndex: 0
	property int randomInterval: Plasmoid.configuration.randomInterval
	property int randomIndex: 0
	property var randomState: ({ picks: {}, lastIndex: -1 })
	property string onClickAction: Plasmoid.configuration.onClickAction
	property string onClickAppCommand: Plasmoid.configuration.onClickAppCommand

	// DataSource for launching applications
	Plasma5Support.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: function(source, data) {
			disconnectSource(source)
		}
	}

	function launchApp(command) {
		if (command && command.trim() !== '') {
			executable.connectSource(command)
		}
	}

	Timer {
		id: flipTimer
		interval: flipInterval
		running: true
		repeat: true
		onTriggered: {
			cycleIndex++
			updateClock()
		}
	}

	Timer {
		id: randomTimer
		interval: randomInterval
		running: true
		repeat: true
		onTriggered: {
			randomIndex++
			updateClock()
		}
	}

	// ------------------------------------------------------------------------------------------------------------------------

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		onClicked: {
			switch (onClickAction) {
				case "calendar":
					mainContainer.toggleExpanded()
					break
				case "launchApp":
					launchApp(onClickAppCommand)
					break
				case "disabled":
				default:
					break
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

	function getActiveUserLayout() {
		switch (activeLayoutSlot) {
			case 2: return Plasmoid.configuration.layout2
			case 3: return Plasmoid.configuration.layout3
			default: return Plasmoid.configuration.layout
		}
	}

	function updateClock() {
		var layoutHtml = useUserLayout
				? getActiveUserLayout()
				: Layouts.layouts[layoutKey]['html']
		var localeToUse = Utils.configuredLocale(Plasmoid.configuration)
		var finalOffsetOrNull = Utils.configuredTzOffset(Plasmoid.configuration)
		var txt = layoutHtml
		txt = Placeholders.expandFlip(txt, cycleIndex)
		txt = Placeholders.expandCycle(txt, cycleIndex)
		txt = Placeholders.expandRandom(txt, randomIndex, randomState)
		clock.text = DTF.format(txt, localeToUse, finalOffsetOrNull)
	}

	// ------------------------------------------------------------------------------------------------------------------------

} // mainContainer
