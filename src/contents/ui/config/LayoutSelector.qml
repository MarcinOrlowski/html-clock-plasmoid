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
import org.kde.plasma.plasmoid
import "../../js/layouts.js" as Layouts

	// -----------------------------------------------------------------------

PlasmaComponents.ComboBox {
	property string selectedLayoutKey: ''

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
	onCurrentIndexChanged: selectedLayoutKey = model[currentIndex]['value']
}
