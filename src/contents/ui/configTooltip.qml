/**
 * Weekday Grid widget for KDE
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2021 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/weekday-plasmoid
 */

import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.5 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents
import "../js/meta.js" as Meta

Kirigami.FormLayout {
	Layout.fillWidth: true

	property alias cfg_tooltipFirstLineFormat: tooltipFirstLineFormat.text
	property alias cfg_tooltipSecondLineFormat: tooltipSecondLineFormat.text

	TextField {
		id: tooltipFirstLineFormat
		Kirigami.FormData.label: i18n('First line')
	}

	TextField {
		id: tooltipSecondLineFormat
		Kirigami.FormData.label: i18n('Second line')
	}

	PlasmaComponents.Label {
		 Layout.alignment: Qt.AlignHCenter
		 textFormat: Text.RichText
		 text: 'See <u>placeholders documentation</u> page.'
		 MouseArea {
			 anchors.fill: parent
			 onClicked: Qt.openUrlExternally(Meta.url)
		 }
	}

	Item {
		Layout.fillWidth: true
		Layout.fillHeight: true
	}

}
