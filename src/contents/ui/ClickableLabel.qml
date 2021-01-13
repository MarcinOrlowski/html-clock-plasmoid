/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2021 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents

PlasmaComponents.Label {
	property string url: ''
	text: ''
	MouseArea {
		anchors.fill: parent
		onClicked: {
			Qt.openUrlExternally(url !== "" ? url : text)
		}
	}
}

