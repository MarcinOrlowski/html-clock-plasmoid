/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2023 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols as KQControls
import org.kde.plasma.components as PlasmaComponents

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
