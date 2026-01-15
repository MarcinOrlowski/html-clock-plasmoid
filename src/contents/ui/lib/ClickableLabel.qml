/**
 * Weekday Grid widget for KDE
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2026 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/weekday-plasmoid
 */

import QtQuick
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.Label {
	// URL to open once the label is clicked.
	property string url: ""

	// Optional label to be shown. If not provided, URL will be used as label.
	text: url

 	textFormat: Text.RichText
	MouseArea {
		anchors.fill: parent
		onClicked: {
			if (url !== "") {
				Qt.openUrlExternally(url)
			} else {
				console.debug('No URL provided.')
			}
		}
	}
}
