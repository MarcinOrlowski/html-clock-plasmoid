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
import org.kde.kquickcontrols 2.0 as KQControls
import org.kde.plasma.components 3.0 as PlasmaComponents

Kirigami.FormLayout {
	Layout.fillWidth: true

	property alias cfg_calendarViewEnabled: calendarViewEnabled.checked
	property alias cfg_showWeekNumbers: showWeekNumbers.checked

//	Item {
//		Kirigami.FormData.label: i18n('Localization')
//		Kirigami.FormData.isSection: true
//	}

	CheckBox {
		id: calendarViewEnabled
		text: i18n("Enable calendar view")
	}

	CheckBox {
		id: showWeekNumbers
		enabled: cfg_calendarViewEnabled
		text: i18n("Show week numbers")
	}

	Item {
		Layout.fillWidth: true
		Layout.fillHeight: true
	}

}
