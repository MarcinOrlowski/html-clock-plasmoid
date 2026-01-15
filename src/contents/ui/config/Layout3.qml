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

	property alias cfg_layout3: layoutTextArea.text
	property alias layoutKey: layoutSelector.selectedLayoutKey
	property bool useCustomFont: Plasmoid.configuration.useCustomFont
	property font customFont: Plasmoid.configuration.customFont
	property int flipInterval: Plasmoid.configuration.flipInterval
	property int cycleIndex: 0

	// Timer to animate {flip} and {cycle} placeholders in preview
	Timer {
		interval: flipInterval
		running: layoutConfigContainer.visible
		repeat: true
		onTriggered: cycleIndex++
	}

	// Process {flip|X|Y} placeholders - flip is cycle with 2 values
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
					text = text.replace(val, valMatch[(cycleIndex % 2) + 1])
				})
			}
		})
		return text
	}

	// Process {cycle|v1|v2|v3|...} placeholders
	function handleCycle(text) {
		var reg = /\{cycle\|([^}]+)\}/gi
		var matches = text.match(reg)
		if (matches !== null) {
			matches.forEach(function(val) {
				var valMatch = val.match(/^\{cycle\|([^}]+)\}$/i)
				if (valMatch) {
					var values = valMatch[1].split('|')
					var selectedValue = values[cycleIndex % values.length]
					text = text.replace(val, selectedValue)
				}
			})
		}
		return text
	}

	Kirigami.InlineMessage {
		id: infoMessageWidget
		Layout.fillWidth: true
		Layout.margins: Kirigami.Units.smallSpacing
		type: Kirigami.MessageType.Information
		text: !Plasmoid.configuration.useUserLayout
			? i18n('You are currently using built-in layout. Enable "Use user layout" in "General" settings to use this layout.')
			: i18n('This slot is not active. Select "Slot 3" in "General" settings to use this layout.')
		showCloseButton: true
		visible: !Plasmoid.configuration.useUserLayout || Plasmoid.configuration.activeLayoutSlot !== 3
		actions: [
			Kirigami.Action {
				text: i18n("Activate this slot")
				icon.name: "checkmark"
				onTriggered: {
					Plasmoid.configuration.useUserLayout = true
					Plasmoid.configuration.activeLayoutSlot = 3
				}
			}
		]
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

		Item {
			anchors.fill: parent
			anchors.margins: 8

			PlasmaComponents.Label {
				id: userLayoutPreview
				anchors.centerIn: parent
				width: parent.width
				horizontalAlignment: Text.AlignHCenter
				textFormat: Text.RichText
				font.family: useCustomFont ? customFont.family : Qt.application.font.family
				font.pointSize: useCustomFont ? customFont.pointSize : Qt.application.font.pointSize
				font.bold: useCustomFont ? customFont.bold : Qt.application.font.bold
				font.italic: useCustomFont ? customFont.italic : Qt.application.font.italic
				font.underline: useCustomFont ? customFont.underline : Qt.application.font.underline
				text: {
					cycleIndex // Force re-evaluation on timer tick
					if (layoutTextArea.text === '') return ''
					var txt = layoutTextArea.text
					txt = handleFlip(txt)
					txt = handleCycle(txt)
					return DTF.format(txt, '', null)
				}
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
				text: i18n('<u>Placeholders</u>')
				url: 'https://github.com/MarcinOrlowski/html-clock-plasmoid'
			}
			ClickableLabel {
				text: i18n('<u>HTML tags</u>')
				url: 'https://doc.qt.io/qt-6/richtext-html-subset.html'
			}
		}
		Item {
			Layout.fillWidth: true
		}
		ClickableLabel {
			Layout.alignment: Qt.AlignRight
			anchors.right: layoutConfigContainer.right
			text: i18n('<u>Share your layout!</u>')
			url: 'https://github.com/MarcinOrlowski/html-clock-plasmoid/discussions/categories/html-clock-templates'
		}
	}

	Item {
		Layout.fillWidth: true
		Layout.fillHeight: true
	}

} // ColumnLayout
