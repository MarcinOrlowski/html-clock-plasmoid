/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2022 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
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
			if (_key === plasmoid.configuration['layoutKey']) _currentIdx = _idx
			_idx++
		}
		model = _tmp
		currentIndex = _currentIdx
	}
	onCurrentIndexChanged: selectedLayoutKey = model[currentIndex]['value']
}

