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

	/*
	** Arguments:
	**           text: string to be wrapped with styled span
	**   selectedFont: font to be used to style the text
	**
	** Returns:
	**   string: text wrapped in CSS styled `<span>` HTML tag.
	*/
	function styleWithFont(text, selectedFont) {
		var htmlText = (text !== '') ? text : i18n('Text')

		var html = '<span style="'
		html += 'font-family: ' + selectedFont.family + '; '
		html += 'font-size: ' + selectedFont.pixelSize + 'px; '
		if (selectedFont.bold) {
			html += 'font-weight: bold; '
		}
		html += `">${text}</span>`

		return html
	}

	function styleWithFontAndColor(text, selectedFont, selectedColor) {
		var htmlText = (text !== '') ? text : i18n('Text')

		var html = '<span style="'
		html += 'font-family: ' + selectedFont.family + '; '
		html += 'font-size: ' + selectedFont.pixelSize + 'px; '
		if (selectedFont.bold) {
			html += 'font-weight: bold; '
		}
		html += 'color: ' + selectedColor.toString() + ';'
		html += `">${text}</span>`

		return html
	}


	function styleWithColor(text, selectedColor) {
		var htmlText = (text !== '') ? text : 'text'
		var html = '<span style="'
		html += 'color: ' + selectedColor.toString() + ';'
		html += `">${htmlText}</span>`

		return html
	}

	// -----------------------------------------------------------------------

	QtControls.TextField {
		id: clipboardHelper
		visible: false

		function doCopy(textToCopy) {
			text = textToCopy
			selectAll()
			copy()
		}
	}

	// -----------------------------------------------------------------------

	property alias cfg_layout: layoutTextArea.text
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

	// -----------------------------------------------------------------------

	RowLayout {
		Layout.fillWidth: true

		PlasmaComponents.ComboBox {
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
			onCurrentIndexChanged: layoutKey = model[currentIndex]['value']
		}

		PlasmaComponents.Button {
			implicitWidth: minimumWidth
			text: i18n('Clone')
			onClicked: layoutTextArea.text = Layouts.layouts[layoutKey]['html'].trim()
		}
	}

	// -----------------------------------------------------------------------

	// Font Helper
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
			anchors.right: layoutConfigContainer.right

			CopyButton {
				onClicked: clipboardHelper.doCopy(fontSelector.selectedFont.family)
			}

			CopyButton {
				text: i18n('HTML')
				onClicked: clipboardHelper.doCopy(styleWithFont(xxxx, fontSelector.selectedFont))
			}
		}
	} // fontHelper

	// -----------------------------------------------------------------------

	// color Helper
	RowLayout {
		id: colorHelper

		KQControls.ColorButton {
			id: colorSelector
			showAlphaChannel: false
			dialogTitle: i18n('Select color')
			onColorChanged: colorValue.text = color.toString()
		}
		QtControls.Label {
			id: colorValue
			Layout.fillWidth: true
		}
		RowLayout {
			anchors.right: layoutConfigContainer.right

			CopyButton {
				onClicked: clipboardHelper.doCopy(colorSelector.color.toString())
			}

			CopyButton {
				text: i18n('HTML')
				onClicked: clipboardHelper.doCopy(styleWithColor(text, colorSelector.color))
			}
			CopyButton {
				text: i18n('CSS')
				onClicked: clipboardHelper.doCopy('color: ' + colorSelector.color.toString() + ';')
			}

		}
	} // color Helper

	// -----------------------------------------------------------------------

	function getTextToStyle() {
		var selStart = layoutTextArea.selectionStart
		var selEnd = layoutTextArea.selectionEnd
		var text = layoutTextArea.text.substring(selStart, selEnd)

		return (text !== '') ? text : 'Text'
	}

	function doReplaceSelection(text) {
		var selStart = layoutTextArea.selectionStart
		var selEnd = layoutTextArea.selectionEnd
		var cursorPosition = layoutTextArea.cursorPosition

		layoutTextArea.remove(selStart, selEnd)
		layoutTextArea.insert(selStart, text)
		layoutTextArea.select(selStart, selStart + text.length)
		layoutTextArea.cursorPosition = cursorPosition
	}

	// Styling selection
	RowLayout {
		PlasmaComponents.Label {
			text: i18n('Style selection with:')
		}
		PlasmaComponents.Button {
			implicitWidth: minimumWidth
			text: i18n('Font')
			onClicked: doReplaceSelection(styleWithFontAndColor(getTextToStyle(), fontSelector.selectedFont, colorSelector.color))
		}

		PlasmaComponents.Button {
			implicitWidth: minimumWidth
			text: i18n('Color')
			onClicked: doReplaceSelection(styleWithColor(getTextToStyle(), colorSelector.color))
		}

		PlasmaComponents.Button {
			implicitWidth: minimumWidth
			text: i18n('Font + Color')
			onClicked: doReplaceSelection(styleWithFontAndColor(getTextToStyle(), fontSelector.selectedFont, colorSelector.color))
		}

	}

	// -----------------------------------------------------------------------

	QtControls.TextArea {
		id: layoutTextArea
		Layout.fillWidth: true
		Layout.fillHeight: true
		selectByMouse: true
		persistentSelection: true
	}

	RowLayout {
		Layout.fillWidth: true
		anchors.left: layoutConfigContainer.left
		anchors.right: layoutConfigContainer.right
		RowLayout {
			PlasmaComponents.Label {
				text: i18n('Docs:')
			}
			ClickableLabel {
				text: '<u>Placeholders</u>'
				url: 'https://github.com/MarcinOrlowski/html-clock-plasmoid'
			}
			ClickableLabel {
				text: '<u>HTML tags</u>'
				url: 'https://doc.qt.io/qt-5/richtext-html-subset.html'
			}
		}
		Item {
			Layout.fillWidth: true
		}
		ClickableLabel {
			Layout.alignment: Qt.AlignRight
			anchors.right: layoutConfigContainer.right
			text: '<u>Share your layout!</u>'
			url: 'https://github.com/MarcinOrlowski/html-clock-plasmoid/issues/new?assignees=&labels=enhancement&template=new_layout.md'
		}
	}

	Item {
		Layout.fillWidth: true
		Layout.fillHeight: true
	}

} // ColumnLayout
