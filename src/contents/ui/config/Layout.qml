/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2026 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick
import QtQuick.Controls as QtControls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols as KQControls
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import "../../js/layouts.js" as Layouts
import "../../js/DateTimeFormatter.js" as DTF
import "../lib"

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
		html += '">' + text + '</span>'

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
		html += '">' + text + '</span>'

		return html
	}


	function styleWithColor(text, selectedColor) {
		var htmlText = (text !== '') ? text : 'text'
		var html = '<span style="'
		html += 'color: ' + selectedColor.toString() + ';'
		html += '">' + htmlText + '</span>'

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
	property alias layoutKey: layoutSelector.selectedLayoutKey
	property bool useCustomFont: Plasmoid.configuration.useCustomFont
	property font customFont: Plasmoid.configuration.customFont
	property int flipInterval: Plasmoid.configuration.flipInterval
	property bool flipState: false

	// Timer to animate {flip} placeholders in preview
	Timer {
		interval: flipInterval
		running: true
		repeat: true
		onTriggered: flipState = !flipState
	}

	// Process {flip:X:Y} placeholders - alternate based on flipState
	function handleFlip(text) {
		// Support both | (new) and : (legacy) separators
		var patterns = [
			{ reg: /\{flip\|(.+?)\|(.+?)\}/gi, valReg: /^\{flip\|(.+?)\|(.+?)\}$/i },
			{ reg: /\{flip:(.+?):(.+?)\}/gi, valReg: /^\{flip:(.+?):(.+?)\}$/i }
		]
		patterns.forEach(function(pattern) {
			var matches = text.match(pattern.reg)
			if (matches !== null) {
				matches.forEach(function(val) {
					var valMatch = val.match(pattern.valReg)
					text = text.replace(val, valMatch[flipState ? 1 : 2])
				})
			}
		})
		return text
	}

	Kirigami.InlineMessage {
		id: infoMessageWidget
		Layout.fillWidth: true
		Layout.margins: Kirigami.Units.smallSpacing
		type: Kirigami.MessageType.Information
		text: i18n('You are currently using built-in layout. No changes made in this pane will be reflected unless you enable "Use user layout" option in "General" settings.')
		showCloseButton: true
		visible: !Plasmoid.configuration.useUserLayout
	}

	// -----------------------------------------------------------------------

	RowLayout {
		Layout.fillWidth: true

		LayoutSelector {
			id: layoutSelector
			showPreview: false
		}

		PlasmaComponents.Button {
			// implicitWidth: minimumWidth
			text: i18n('Clone')
			onClicked: layoutTextArea.text = Layouts.layouts[layoutKey]['html'].trim()
		}
	}

	// -----------------------------------------------------------------------

	// Font Helper
	RowLayout {
		id: fontHelper
		property bool isFontSelected: false

		FontSelector {
			id: fontSelector
			onSelectedFontChanged: {
				fontFamilyName.text = selectedFont.family
				fontFamilyName.font.family = selectedFont.family
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

		if (selStart === selEnd) {
			noTextSelectedMessage.visible = true
		} else {
			noTextSelectedMessage.visible = false

			var cursorPosition = layoutTextArea.cursorPosition
			layoutTextArea.remove(selStart, selEnd)
			layoutTextArea.insert(selStart, text)
			layoutTextArea.cursorPosition = cursorPosition

			if (keepSelection.checked) layoutTextArea.select(selStart, selStart + text.length)
		}
	}

	Kirigami.InlineMessage {
		id: noTextSelectedMessage
		Layout.fillWidth: true
		Layout.margins: Kirigami.Units.smallSpacing
		type: Kirigami.MessageType.Error
		text: i18n('No text selected.')
		showCloseButton: true
	}


	// Styling selection
	RowLayout {
		PlasmaComponents.Label {
			text: i18n('Style selection:')
		}
		PlasmaComponents.Button {
			// implicitWidth: minimumWidth
			text: i18n('Font')
			onClicked: doReplaceSelection(styleWithFontAndColor(getTextToStyle(), fontSelector.selectedFont, colorSelector.color))
		}

		PlasmaComponents.Button {
			// implicitWidth: minimumWidth
			text: i18n('Color')
			onClicked: doReplaceSelection(styleWithColor(getTextToStyle(), colorSelector.color))
		}

		PlasmaComponents.Button {
			// implicitWidth: minimumWidth
			text: i18n('Font + Color')
			onClicked: doReplaceSelection(styleWithFontAndColor(getTextToStyle(), fontSelector.selectedFont, colorSelector.color))
		}

		Item {
			Layout.fillWidth: true
		}

		QtControls.CheckBox {
			anchors.right: layoutConfigContainer.right
			id: keepSelection
			text: i18n("Retain selection")
		}

	}

	// -----------------------------------------------------------------------

	// Live preview
	Rectangle {
		Layout.fillWidth: true
		Layout.preferredHeight: 100
		clip: true
		color: Kirigami.Theme.backgroundColor
		border.color: Kirigami.Theme.disabledTextColor
		border.width: 1
		radius: 4

		PlasmaComponents.Label {
			id: userLayoutPreview
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
				flipState // Force re-evaluation on timer tick
				if (layoutTextArea.text === '') return ''
				return DTF.format(handleFlip(layoutTextArea.text), '', null)
			}
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
				url: 'https://doc.qt.io/qt-6/richtext-html-subset.html'
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
