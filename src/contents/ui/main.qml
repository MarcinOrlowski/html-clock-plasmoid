/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2021 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.1
import org.kde.plasma.calendar 2.0 as PlasmaCalendar
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import "../js/DateTimeFormatter.js" as DTF
import "../js/meta.js" as Meta

Item {
	id: root

	// ------------------------------------------------------------------------------------------------------------------------

	Component.onCompleted: {
		plasmoid.setAction("showAboutDialog", i18n('About %1…', Meta.title));
		plasmoid.setAction("checkUpdateAvailability", i18n("Check update…"));
	}

	function action_checkUpdateAvailability() {
		updateChecker.checkUpdateAvailability(true)
	}

	function action_showAboutDialog() {
		aboutDialog.visible = true
	}
	AboutDialog {
		id: aboutDialog
	}

	// ------------------------------------------------------------------------------------------------------------------------

	PlasmaCore.DataSource {
		id: dataSource
		engine: "time"
//		  connectedSources: allTimezones
//		  interval: plasmoid.configuration.showSeconds ? 1000 : 60000
//		  intervalAlignment: plasmoid.configuration.showSeconds ? PlasmaCore.Types.NoAlignment : PlasmaCore.Types.AlignToMinute
		connectedSources: ["Local", "UTC"]
		interval: 60000
		intervalAlignment: PlasmaCore.Types.AlignToMinute
	}

	property date tzDate: {
		// get the time for the given timezone from the dataengine
		var now = dataSource.data["Local"]["DateTime"];
		// get current UTC time
		var msUTC = now.getTime() + (now.getTimezoneOffset() * 60000);
		// add the dataengine TZ offset to it
		return new Date(msUTC + (dataSource.data["Local"]["Offset"] * 1000));
	}

	// ------------------------------------------------------------------------------------------------------------------------

	Plasmoid.toolTipMainText: {
		var localeToUse = plasmoid.configuration.useSpecificLocaleEnabled
			? plasmoid.configuration.useSpecificLocaleLocaleName
			: ''
		return DTF.format(plasmoid.configuration.tooltipFirstLineFormat, localeToUse)
	}
	Plasmoid.toolTipSubText: {
		var localeToUse = plasmoid.configuration.useSpecificLocaleEnabled
			? plasmoid.configuration.useSpecificLocaleLocaleName
			: ''
		return DTF.format(plasmoid.configuration.tooltipSecondLineFormat, localeToUse)
	}

	// ------------------------------------------------------------------------------------------------------------------------

	Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
	Plasmoid.compactRepresentation: HtmlClock { }
	Plasmoid.fullRepresentation: CalendarView { }

	// ------------------------------------------------------------------------------------------------------------------------

	UpdateChecker {
		id: updateChecker

		// once per 7 days
		checkInterval: (((1000*60)*60)*24*7)
	}

} // root
