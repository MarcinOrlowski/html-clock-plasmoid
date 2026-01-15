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

// -----------------------------------------------------------------------

ColumnLayout {
	id: root

	property string selectedLayoutKey: ''
	property bool showPreview: true
	property bool useCustomFont: Plasmoid.configuration.useCustomFont
	property font customFont: Plasmoid.configuration.customFont
	property int tick: 0

	spacing: Kirigami.Units.smallSpacing

	// Timer to animate {flip} placeholders in preview
	Timer {
		interval: 1000
		running: showPreview
		repeat: true
		onTriggered: tick++
	}

	// Process {flip:X:Y} placeholders - alternate based on current second
	function handleFlip(text) {
		var reg = new RegExp('\{flip:(.+?):(.+?)\}', 'gi')
		var matches = text.match(reg)
		if (matches !== null) {
			var even = (new Date()).getSeconds() % 2
			var valReg = new RegExp('^\{flip:(.+?):(.+?)\}$', 'i')
			matches.forEach(function(val) {
				var valMatch = val.match(valReg)
				text = text.replace(val, valMatch[even ? 1 : 2])
			})
		}
		return text
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
				tick // Force re-evaluation on timer tick
				if (root.selectedLayoutKey === '' || !Layouts.layouts[root.selectedLayoutKey]) {
					return ''
				}
				var html = Layouts.layouts[root.selectedLayoutKey]['html']
				return DTF.format(handleFlip(html), '', null)
			}
		}
	}
}
