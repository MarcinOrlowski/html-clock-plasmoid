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
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import "../../js/layouts.js" as Layouts
import "../../js/DateTimeFormatter.js" as DTF
import "../../js/placeholders.js" as Placeholders
import "../../js/utils.js" as Utils

// -----------------------------------------------------------------------

ColumnLayout {
	id: root

	property string selectedLayoutKey: ''
	property bool showPreview: true
	property bool useCustomFont: Plasmoid.configuration.useCustomFont
	property font customFont: Plasmoid.configuration.customFont
	property int flipInterval: Plasmoid.configuration.flipInterval
	property int cycleIndex: 0

	property string previewLocale: Utils.configuredLocale(Plasmoid.configuration)
	property var previewTzOffset: Utils.configuredTzOffset(Plasmoid.configuration)

	spacing: Kirigami.Units.smallSpacing

	// Timer to animate {flip} and {cycle} placeholders in preview
	Timer {
		interval: flipInterval
		running: showPreview
		repeat: true
		onTriggered: cycleIndex++
	}

	PlasmaComponents.ComboBox {
		id: layoutComboBox

		Layout.fillWidth: true
		textRole: "text"
		model: []

		Component.onCompleted: {
			var _tmp = []
			var _idx = 0
			var _currentIdx = undefined
			for(const _key in Layouts.layouts) {
				var _name = Layouts.layouts[_key]['name']
				_tmp.push({'value': _key, 'text': _name})
				if (_key === Plasmoid.configuration['layoutKey']) _currentIdx = _idx
				_idx++
			}
			model = _tmp
			currentIndex = _currentIdx
		}

		onCurrentIndexChanged: {
			if (model.length > 0 && currentIndex >= 0) {
				root.selectedLayoutKey = model[currentIndex]['value']
			}
		}
	}

	// Preview container
	Rectangle {
		visible: showPreview
		Layout.preferredWidth: 250
		Layout.preferredHeight: 120
		clip: true
		color: Kirigami.Theme.backgroundColor
		border.color: Kirigami.Theme.disabledTextColor
		border.width: 1
		radius: 4

		PlasmaComponents.Label {
			id: previewLabel
			anchors.fill: parent
			anchors.margins: Kirigami.Units.largeSpacing
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			textFormat: Text.RichText
			font.family: useCustomFont ? customFont.family : Qt.application.font.family
			font.pointSize: useCustomFont ? customFont.pointSize : Qt.application.font.pointSize
			font.bold: useCustomFont ? customFont.bold : Qt.application.font.bold
			font.italic: useCustomFont ? customFont.italic : Qt.application.font.italic
			font.underline: useCustomFont ? customFont.underline : Qt.application.font.underline
			text: {
				cycleIndex // Force re-evaluation on timer tick
				if (root.selectedLayoutKey === '' || !Layouts.layouts[root.selectedLayoutKey]) {
					return ''
				}
				// Built-in layouts never use {random}, so it is not expanded here.
				var html = Layouts.layouts[root.selectedLayoutKey]['html']
				html = Placeholders.expandFlip(html, cycleIndex)
				html = Placeholders.expandCycle(html, cycleIndex)
				return DTF.format(html, previewLocale, previewTzOffset)
			}
		}
	}
}
