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
	id: layoutConfigContainer

	Layout.fillWidth: true
	Layout.fillHeight: true

	// -----------------------------------------------------------------------

	property alias cfg_layout: textInput.text

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

	RowLayout {
		id: fontHelper
		property bool isFontSelected: false

		ConfigFontSelector {
			id: fontSelector
			onSelectedFontChanged: {
				fontFamilyName.text = selectedFont.family
				parent.isFontSelected = true
			}
		}

		QtControls.Label {
			id: fontFamilyName
			Layout.fillWidth: true
		}

		RowLayout {
			enabled: fontHelper.isFontSelected
			anchors.right: layoutConfigContainer.anchors.right
			PlasmaComponents.Button {
				icon.name: 'edit-copy'
				enabled: fontHelper.isFontSelected
				onClicked: {
					clipboardHelper.text = fontSelector.selectedFont.family
					clipboardHelper.selectAll()
					clipboardHelper.copy()
				}
			}
			PlasmaComponents.Button {
				icon.name: 'edit-copy'
				text: i18n('as HTML')
				onClicked: {
					var html = '<span style="'
					html += 'font-family: ' + fontSelector.selectedFont.family + '; '
					html += 'font-size: ' + fontSelector.selectedFont.pixelSize + 'px; '
					if (fontSelector.selectedFont.bold) html += 'font-weight: bold; '
					html += '">Text</span>'
					clipboardHelper.text = html
					clipboardHelper.selectAll()
					clipboardHelper.copy()
				}
			}
		}

		QtControls.TextField {
			id: clipboardHelper
			visible: false
		}
	}

	QtControls.TextArea {
		id: textInput
		Layout.fillWidth: true
		Layout.fillHeight: true
		selectByMouse: true
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
