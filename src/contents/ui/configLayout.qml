/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2021 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.0
import QtQuick.Controls 2.3 as QtControls
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kquickcontrols 2.0 as KQControls
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import "../js/layouts.js" as Layouts

ColumnLayout {
	Layout.fillWidth: true
	Layout.fillHeight: true

	// -----------------------------------------------------------------------

	property alias cfg_layout: textInput.text
	property alias cfg_fontPixelSize: fontPixelSize.value

	property string layoutKey: undefined

	Kirigami.InlineMessage {
		id: infoMessageWidget
		Layout.fillWidth: true
		Layout.margins: Kirigami.Units.smallSpacing
		type: Kirigami.MessageType.Information
		text: i18n('You are currently using built-in layout. No changes made in this pane will be reflected unless you enable "Use user layout" option in "General" settings.')
		showCloseButton: true
		visible: !plasmoid.configuration.useUserLayout
	}

	RowLayout {
		Layout.fillWidth: true

		PlasmaComponents.ComboBox {
			textRole: "text"
			model: []
			Component.onCompleted: {
				var tmp = []
				var idx = 0
				var currentIdx = undefined
				for(const key in Layouts.layouts) {
					var name = Layouts.layouts[key]['name']
					tmp.push({'value':key, 'text': name})
					if (key === plasmoid.configuration['layoutKey']) currentIdx = idx
					idx++
				}
				model = tmp

				currentIndex = currentIdx
			}
			onCurrentIndexChanged: layoutKey = model[currentIndex]['value']
		}

		PlasmaComponents.Button {
			text: i18n('Clone')
			onClicked: textInput.text = Layouts.layouts[layoutKey]['html'].trim()
		}
	} // themeSelector

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
	} // TextArea

	Kirigami.FormLayout {
		anchors.left: parent.left
		anchors.right: parent.right

		PlasmaComponents.SpinBox {
			id: fontPixelSize
			editable: true
			from: 1
			to: 100
			stepSize: 1
			Kirigami.FormData.label: i18n("Base font pixel size")
		}
	}

	RowLayout {
		PlasmaComponents.Label {
			text: 'Created fancy layout?'
		}
		ClickableLabel {
			text: '<u>Share it!</u>'
			url: 'https://github.com/MarcinOrlowski/html-clock-plasmoid/issues/new?assignees=&labels=enhancement&template=new_layout.md'
		}
	}

	RowLayout {
		PlasmaComponents.Label {
			text: 'Documentation: '
		}
		ClickableLabel {
			text: '<u>Placeholders</u>'
			url: 'https://github.com/MarcinOrlowski/html-clock-plasmoid'
		}
		ClickableLabel {
			text: '<u>Supported HTML tags</u>'
			url: 'https://doc.qt.io/qt-5/richtext-html-subset.html'
		}
	}

	Item {
		Layout.fillWidth: true
		Layout.fillHeight: true
	}

} // ColumnLayout
