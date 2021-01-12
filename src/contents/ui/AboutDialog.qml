/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2021 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.3
import org.kde.plasma.components 3.0 as PlasmaComponents
import QtQuick.Dialogs 1.3
import "../js/meta.js" as Meta

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

/*
		Image {
			id: aboutLogo
			Layout.alignment: Qt.AlignHCenter
			fillMode: Image.PreserveAspectFit
			source: plasmoid.file('', 'images/logo.png')
		} // aboutLogo
*/

		// metadata access is not available until very recent Plasma
		// so as a work around we have it auto-generated as JS file
		PlasmaComponents.Label {
			Layout.alignment: Qt.AlignHCenter
			textFormat: Text.PlainText
			font.bold: true
			font.pixelSize: Qt.application.font.pixelSize * 1.5
			text: `${Meta.title} v${Meta.version}`
		}

		PlasmaComponents.Label {
			Layout.alignment: Qt.AlignHCenter
			textFormat: Text.RichText
			text: {
				var year = '2020'
				var currentYear = new Date().getFullYear()
				if (currentYear != year) {
					year += `-${currentYear}`
				}
				return `&copy;${year} by <strong><u>Marcin Orlowski</u></strong>`
			}
			MouseArea {
				anchors.fill: parent
				onClicked: Qt.openUrlExternally(Meta.authorUrl)
			}
		}

		Item {
			height: 20
		}

		PlasmaComponents.Label {
			Layout.alignment: Qt.AlignHCenter
			textFormat: Text.RichText
			text: i18n('Visit <u>project page</u> on Github')
			MouseArea {
				anchors.fill: parent
				onClicked: {
					Qt.openUrlExternally(Meta.url)
				}
			}
		}

	} // aboutMainContainer

} // Dialog
