/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2023 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.config as KConfig
import org.kde.kcmutils as KCMUtils

import "../js/DateTimeFormatter.js" as DTF
import "../js/meta.js" as Meta
import "../js/utils.js" as Utils

PlasmoidItem {
	id: root
	
	// ------------------------------------------------------------------------------------------------------------------------
	Plasmoid.contextualActions: [
		PlasmaCore.Action {
			text: i18n("Check update…")
			onTriggered: updateChecker.checkUpdateAvailability(true)
		},
		PlasmaCore.Action {
			text: i18n("Adjust Date and Time…")
			icon.name: "clock"
			visible: KConfig.KAuthorized.authorize("kcm_clock")
			onTriggered: KCMUtils.KCMLauncher.openSystemSettings("kcm_clock")
		},
		PlasmaCore.Action {
			text: i18n("Set Time Format…")
			icon.name: "gnumeric-format-thousand-separator"
			visible: KConfig.KAuthorized.authorizeControlModule("kcm_regionandlang")
			onTriggered: KCMUtils.KCMLauncher.openSystemSettings("kcm_regionandlang")
		}
	]

	// ------------------------------------------------------------------------------------------------------------------------

	Plasma5Support.DataSource {
		id: dataSource
		engine: "time"
//		  connectedSources: allTimezones
//		  interval: plasmoid.configuration.showSeconds ? 1000 : 60000
//		  intervalAlignment: plasmoid.configuration.showSeconds ? Plasma5Support.Types.NoAlignment : Plasma5Support.Types.AlignToMinute
		connectedSources: {
			return [
				"Local",
				"UTC",
			]
		}
		interval: 60000
		intervalAlignment: Plasma5Support.Types.NoAlignment
	}

	// Used by CalendarView.qml component
	property date localDate: {
		// get the time for the given timezone from the dataengine
		return dataSource.data["Local"]["DateTime"];
	}

	// ------------------------------------------------------------------------------------------------------------------------

	property string tooltipMainText: ''
	property string tooltipSubText: ''

	Plasma5Support.DataSource {
		engine: "time"
		connectedSources: ["Local"]
		interval: 1000
		intervalAlignment: Plasma5Support.Types.NoAlignment
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

	toolTipMainText: tooltipMainText
	toolTipSubText: tooltipSubText

	// ------------------------------------------------------------------------------------------------------------------------

	preferredRepresentation: compactRepresentation
	compactRepresentation: HtmlClock {
		activeFocusOnTab: true
}
	fullRepresentation: CalendarView {}

	Plasmoid.backgroundHints: Plasmoid.configuration.transparentBackgroundEnabled 
																											? PlasmaCore.Types.ShadowBackground | PlasmaCore.Types.ConfigurableBackground 
																											: PlasmaCore.Types.DefaultBackground
	
	hideOnWindowDeactivate: !Plasmoid.configuration.pin	

	// ------------------------------------------------------------------------------------------------------------------------

	UpdateChecker {
		id: updateChecker

		// once per 7 days
		checkInterval: (((1000 * 60) * 60) * 24 * 7)
	}

} // root
