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

	property alias cfg_useSpecificLocaleEnabled: useSpecificLocaleEnabled.checked
	property alias cfg_useSpecificLocaleLocaleName: useSpecificLocaleLocaleName.text
	property alias cfg_nonDefaultWeekStartDayEnabled: nonDefaultWeekStartDayEnabled.checked
	property alias cfg_nonDefaultWeekStartDayDayIndex: nonDefaultWeekStartDayDayIndex.currentIndex

	RowLayout {
		CheckBox {
			id: useSpecificLocaleEnabled
			text: i18n("Use non default locale")
		}

		TextField {
			id: useSpecificLocaleLocaleName
			enabled: cfg_useSpecificLocaleEnabled
			Kirigami.FormData.label: i18n('Name of locale')
		}
	}

	RowLayout {
		CheckBox {
			id: nonDefaultWeekStartDayEnabled
			text: i18n("Use non default week start day")
		}

		PlasmaComponents.ComboBox {
			id: nonDefaultWeekStartDayDayIndex
			enabled: cfg_nonDefaultWeekStartDayEnabled

			// This is to make it work on pre Qt5.14
			// https://develop.kde.org/docs/plasma/widget/plasma-qml-api/#combobox---multiple-choice
			property string _valueRole: "value"
			readonly property var _currentValue: _valueRole && currentIndex >= 0 ? model[currentIndex][_valueRole] : null

			textRole: "text"
			model: [
				{ value: 0, text: i18n("Sunday") },
				{ value: 1, text: i18n("Monday") },
				{ value: 2, text: i18n("Tuesday") },
				{ value: 3, text: i18n("Wednesday") },
				{ value: 4, text: i18n("Thursday") },
				{ value: 5, text: i18n("Friday") },
				{ value: 6, text: i18n("Saturday") },
			]
		}
	}

	Item {
		Layout.fillWidth: true
		Layout.fillHeight: true
	}

}
