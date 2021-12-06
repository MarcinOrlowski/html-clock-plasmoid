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
import "../js/utils.js" as Utils

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
		connectedSources: {
			return [
				"Local",
				"UTC",
			]
		}
		interval: 60000
		intervalAlignment: PlasmaCore.Types.NoAlignment
	}

	// ------------------------------------------------------------------------------------------------------------------------

	property string tooltipMainText: ''
	property string tooltipSubText: ''

	PlasmaCore.DataSource {
		engine: "time"
		connectedSources: ["Local"]
		interval: 1000
		intervalAlignment: PlasmaCore.Types.NoAlignment
		onDataChanged: {
			var localeToUse = plasmoid.configuration.useSpecificLocaleEnabled
				? plasmoid.configuration.useSpecificLocaleLocaleName
				: ''
			var finalOffsetOrNull = plasmoid.configuration.clockTimezoneOffsetEnabled
				? Utils.parseTimezoneOffset(plasmoid.configuration.clockTimezoneOffset)
				: null
			tooltipMainText = DTF.format(plasmoid.configuration.tooltipFirstLineFormat, localeToUse, finalOffsetOrNull)
			tooltipSubText = DTF.format(plasmoid.configuration.tooltipSecondLineFormat, localeToUse, finalOffsetOrNull)
		}
	}

	Plasmoid.toolTipMainText: tooltipMainText
	Plasmoid.toolTipSubText: tooltipSubText

	// ------------------------------------------------------------------------------------------------------------------------

	Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
	Plasmoid.compactRepresentation: HtmlClock { }
	Plasmoid.fullRepresentation: CalendarView { }

	// If ConfigurableBackground is set, the we most likely run on Plasma 5.19+ and if so, we prefer using
	// widget's background control features instead.
	Plasmoid.backgroundHints: (typeof PlasmaCore.Types.ConfigurableBackground !== "undefined"
		? PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground
		: plasmoid.configuration.transparentBackgroundEnabled ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground
	)

	// ------------------------------------------------------------------------------------------------------------------------

	UpdateChecker {
		id: updateChecker

		// once per 7 days
		checkInterval: (((1000*60)*60)*24*7)
	}

} // root
