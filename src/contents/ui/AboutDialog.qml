/**
 * Weekday Grid widget for KDE
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2023 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/weekday-plasmoid
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import QtQuick.Dialogs
import "../js/meta.js" as Meta
import "lib"

Dialog {
	visible: false
	title: i18n('Information')
	standardButtons: StandardButton.Ok

	width: 600
	height: 500
	Layout.minimumWidth: 600
	Layout.minimumHeight: 500

	ColumnLayout {
		id: aboutMainContainer

		anchors.centerIn: parent
		Layout.fillWidth: true
		Layout.fillHeight: true
		Layout.margins: 30

		Image {
			id: aboutLogo
			Layout.alignment: Qt.AlignHCenter
			fillMode: Image.PreserveAspectFit
			source: plasmoid.configuration.root + '/images/logo.png'
		}

		// metadata access is not available until very recent Plasma
		// so as a work around we have it auto-generated as JS file
		PlasmaComponents.Label {
			Layout.alignment: Qt.AlignHCenter
			textFormat: Text.PlainText
			font.bold: true
			font.pixelSize: Qt.application.font.pixelSize * 1.5
			text: Meta.title + ' v' + Meta.version
		}

		CopyrightLabel { }

		Item {
			height: 20
		}

		ClickableLabel {
			Layout.alignment: Qt.AlignHCenter
			text: i18n('Visit <u>project page</u> on Github')
			url: Meta.url
		}

	} // aboutMainContainer

} // Dialog
