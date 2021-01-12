/**
 * Weekday Grid widget for KDE
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2021 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/weekday-plasmoid
 */

import QtQuick 2.0
import QtQuick.Controls 2.3 as QtControls
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kquickcontrols 2.0 as KQControls
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import "../js/themes.js" as Themes

ColumnLayout {
	Layout.fillWidth: true
	Layout.fillHeight: true

	// -----------------------------------------------------------------------

	property alias cfg_layout: textInput.text

	QtControls.TextArea {
		id: textInput
		Layout.fillWidth: true
		Layout.fillHeight: true
		selectByMouse: true

		MouseArea {
			anchors.fill: parent
			acceptedButtons: Qt.RightButton
			hoverEnabled: true
			onClicked: {
				var selectStart = textInput.selectionStart;
				var selectEnd = textInput.selectionEnd;
				var curPos = textInput.cursorPosition;
				contextMenu.x = mouse.x;
				contextMenu.y = mouse.y;
				contextMenu.open();
				textInput.cursorPosition = curPos;
				textInput.select(selectStart,selectEnd);
			}
			onPressAndHold: {
				if (mouse.source === Qt.MouseEventNotSynthesized) {
					var selectStart = textInput.selectionStart;
					var selectEnd = textInput.selectionEnd;
					var curPos = textInput.cursorPosition;
					contextMenu.x = mouse.x;
					contextMenu.y = mouse.y;
					contextMenu.open();
					textInput.cursorPosition = curPos;
					textInput.select(selectStart,selectEnd);
				}
			}

			QtControls.Menu {
				id: contextMenu
				QtControls.MenuItem {
					text: i18n("Cut")
					onTriggered: textInput.cut()
				}
				QtControls.MenuItem {
					text: i18n("Copy")
					onTriggered: textInput.copy()
				}
				QtControls.MenuItem {
					text: i18n("Paste")
					onTriggered: textInput.paste()
				}
			}
		}
	}

	Item {
		Layout.fillWidth: true
		Layout.fillHeight: true
	}

} // ColumnLayout
