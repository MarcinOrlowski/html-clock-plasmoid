/**
 * Weekday Grid widget for KDE
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2022 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/weekday-plasmoid
 */

import QtQuick 2.0
import org.kde.plasma.configuration 2.0

ConfigModel {
	ConfigCategory {
		name: i18n("General")
		icon: "view-visible"
		source: "config/General.qml"
	}
	ConfigCategory {
		name: i18n("User Layout")
		icon: "view-visible"
		source: "config/Layout.qml"
	}
	ConfigCategory {
		name: i18n("Calendar View")
		icon: "view-calendar"
		source: "config/Calendar.qml"
	}
	ConfigCategory {
		name: i18n("Tooltip")
		icon: "view-calendar-workweek"
		source: "config/Tooltip.qml"
	}
}
