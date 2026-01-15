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
	property int activeLayoutSlot: Plasmoid.configuration.activeLayoutSlot
	property bool useCustomFont: Plasmoid.configuration.useCustomFont
	property font customFont: Plasmoid.configuration.customFont
	property bool widgetContainerFillWidth: Plasmoid.configuration.widgetContainerFillWidth
	property bool widgetContainerFillHeight: Plasmoid.configuration.widgetContainerFillHeight
	property int flipInterval: Plasmoid.configuration.flipInterval
	property int cycleIndex: 0
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
		var localeToUse = Plasmoid.configuration.useSpecificLocaleEnabled
				? Plasmoid.configuration.useSpecificLocaleLocaleName
				: ''
		var finalOffsetOrNull = Plasmoid.configuration.clockTimezoneOffsetEnabled
			? Utils.parseTimezoneOffset(Plasmoid.configuration.clockTimezoneOffset)
			: null
		var txt = layoutHtml
		txt = handleFlip(txt)
		txt = handleCycle(txt)
		txt = handleRandom(txt)
		clock.text = DTF.format(txt, localeToUse, finalOffsetOrNull)
	}

	function handleFlip(text) {
		// Support both | (new) and : (legacy) separators
		// flip is just cycle with 2 values, uses cycleIndex % 2
		var patterns = [
			{ reg: /\{flip\|(.+?)\|(.+?)\}/gi, valReg: /^\{flip\|(.+?)\|(.+?)\}$/i },
			{ reg: /\{flip:(.+?):(.+?)\}/gi, valReg: /^\{flip:(.+?):(.+?)\}$/i }
		]
		patterns.forEach(function(pattern) {
			var matches = text.match(pattern.reg)
			if (matches !== null) {
				matches.forEach(function (val) {
					var valMatch = val.match(pattern.valReg)
					text = text.replace(val, valMatch[(cycleIndex % 2) + 1])
				})
			}
		})
		return text
	}

	function handleCycle(text) {
		// Match {cycle|val1|val2|val3|...} with variable number of values
		var reg = /\{cycle\|([^}]+)\}/gi
		var matches = text.match(reg)
		if (matches !== null) {
			matches.forEach(function (val) {
				var valMatch = val.match(/^\{cycle\|([^}]+)\}$/i)
				if (valMatch) {
					var values = valMatch[1].split('|')
					var selectedValue = values[cycleIndex % values.length]
					text = text.replace(val, selectedValue)
				}
			})
		}
		return text
	}

	// Store last picked index for each {random} pattern to avoid repetition
	property var randomLastPicks: ({})
	property real randomLastPickTime: 0

	function handleRandom(text) {
		// Match {random|val1|val2|val3|...} with variable number of values
		var reg = /\{random\|([^}]+)\}/gi
		var matches = text.match(reg)
		if (matches !== null) {
			// Only pick new values if enough time has passed (80% of flipInterval)
			var now = Date.now()
			var needNewPick = (now - randomLastPickTime) >= (flipInterval * 0.8)
			if (needNewPick) {
				randomLastPickTime = now
			}

			matches.forEach(function (val) {
				var valMatch = val.match(/^\{random\|([^}]+)\}$/i)
				if (valMatch) {
					var values = valMatch[1].split('|')
					var lastIndex = randomLastPicks[val]

					if (needNewPick) {
						var newIndex
						if (values.length <= 1) {
							newIndex = 0
						} else {
							// Pick random index different from last
							do {
								newIndex = Math.floor(Math.random() * values.length)
							} while (newIndex === lastIndex)
						}
						randomLastPicks[val] = newIndex
						lastIndex = newIndex
					}

					text = text.replace(val, values[lastIndex !== undefined ? lastIndex : 0])
				}
			})
		}
		return text
	}

	// ------------------------------------------------------------------------------------------------------------------------

} // mainContainer
