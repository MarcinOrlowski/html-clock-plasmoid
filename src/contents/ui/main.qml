/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2026 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support
import "../js/DateTimeFormatter.js" as DTF
import "../js/utils.js" as Utils

PlasmoidItem {
	id: root

	// Disable default context menu actions
	Plasmoid.contextualActions: []

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
	property date tzDate: {
		// get the time for the given timezone from the dataengine
		var now = dataSource.data["Local"]["DateTime"];
		// get current UTC time
		var msUTC = now.getTime() + (now.getTimezoneOffset() * 60000);
		// add the dataengine TZ offset to it
		return new Date(msUTC + (dataSource.data["Local"]["Offset"] * 1000));
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
			var localeToUse = Utils.configuredLocale(Plasmoid.configuration)
			var finalOffsetOrNull = Utils.configuredTzOffset(Plasmoid.configuration)
			tooltipMainText = DTF.format(Plasmoid.configuration.tooltipFirstLineFormat, localeToUse, finalOffsetOrNull)
			tooltipSubText = DTF.format(Plasmoid.configuration.tooltipSecondLineFormat, localeToUse, finalOffsetOrNull)
		}
	}

	toolTipMainText: tooltipMainText
	toolTipSubText: tooltipSubText

	// ------------------------------------------------------------------------------------------------------------------------

	preferredRepresentation: compactRepresentation
	compactRepresentation: HtmlClock {
		onToggleExpanded: root.expanded = !root.expanded
	}
	fullRepresentation: CalendarView { }

	// Without this hint the panel containment insets the widget by the panel
	// background margins (Layout.topMargin/bottomMargin in the panel
	// containment), which shows up as blank padding around the clock and makes
	// the usable panel thickness smaller than the panel itself.
	Plasmoid.constraintHints: Plasmoid.CanFillArea

	// Plasma 6 always supports configurable background
	Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground

} // root
