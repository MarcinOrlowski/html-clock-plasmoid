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

	spacing: Kirigami.Units.smallSpacing

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
		Layout.fillWidth: true
		Layout.preferredHeight: 80
		color: Kirigami.Theme.backgroundColor
		border.color: Kirigami.Theme.disabledTextColor
		border.width: 1
		radius: 4

		PlasmaComponents.Label {
			id: previewLabel
			anchors.centerIn: parent
			textFormat: Text.RichText
			text: {
				if (root.selectedLayoutKey === '' || !Layouts.layouts[root.selectedLayoutKey]) {
					return ''
				}
				var html = Layouts.layouts[root.selectedLayoutKey]['html']
				return DTF.format(html, '', null)
			}
		}
	}
}
