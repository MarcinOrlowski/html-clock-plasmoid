/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2026 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support
import "../js/DateTimeFormatter.js" as DTF
import "../js/layouts.js" as Layouts
import "../js/placeholders.js" as Placeholders
import "../js/utils.js" as Utils

ColumnLayout {
	id: mainContainer
	spacing: 0

	// The clock renders before the panel can resize the widget around it, so a
	// value longer than the one before it would paint over the neighbouring
	// widgets for a frame. Clipping keeps those pixels inside the widget [#166].
	//
	// Only while the clock really is too wide, because clipping cuts height as
	// well: "line-height" below 100% makes QT report a text height smaller than
	// the pixels it then draws, and permanent clipping would shave the
	// descenders off such a layout in a tight vertical panel [#166].
	clip: clock.implicitWidth > width + 0.5

	// Signal to notify parent to toggle expanded state
	signal toggleExpanded()

	// ------------------------------------------------------------------------------------------------------------------------

	property string layoutKey: Plasmoid.configuration.layoutKey
	property bool useUserLayout: Plasmoid.configuration.useUserLayout
	property int activeLayoutSlot: Plasmoid.configuration.activeLayoutSlot
	property bool useCustomFont: Plasmoid.configuration.useCustomFont
	property font customFont: Plasmoid.configuration.customFont
	property bool widgetContainerFillHeight: Plasmoid.configuration.widgetContainerFillHeight
	property bool enforceWidgetMinWidth: Plasmoid.configuration.enforceWidgetMinWidth
	property int widgetMinWidth: Plasmoid.configuration.widgetMinWidth
	property bool enforceWidgetMaxWidth: Plasmoid.configuration.enforceWidgetMaxWidth
	property int widgetMaxWidth: Plasmoid.configuration.widgetMaxWidth
	property int flipInterval: Plasmoid.configuration.flipInterval
	property int cycleIndex: 0
	property int randomInterval: Plasmoid.configuration.randomInterval
	property int randomIndex: 0
	property var randomState: ({ picks: {}, lastIndex: -1 })
	property string onClickAction: Plasmoid.configuration.onClickAction
	property string onClickAppCommand: Plasmoid.configuration.onClickAppCommand

	// DataSource for launching applications
	Plasma5Support.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: function(source, data) {
			disconnectSource(source)
		}
	}

	function launchApp(command) {
		if (command && command.trim() !== '') {
			executable.connectSource(command)
		}
	}

	Timer {
		id: flipTimer
		interval: flipInterval
		running: true
		repeat: true
		onTriggered: {
			cycleIndex++
			updateClock()
		}
	}

	Timer {
		id: randomTimer
		interval: randomInterval
		running: true
		repeat: true
		onTriggered: {
			randomIndex++
			updateClock()
		}
	}

	// ------------------------------------------------------------------------------------------------------------------------

	// A TapHandler, not a MouseArea. This root is a ColumnLayout, and anchoring
	// an item inside a layout is undefined behavior in QtQuick: the layout took
	// the filled width of the old MouseArea as a size hint, which pushed the
	// clock off centre as soon as the widget became wider than its text [#166].
	// Handlers are not items, so the layout never sees this one.
	TapHandler {
		onTapped: {
			switch (onClickAction) {
				case "calendar":
					mainContainer.toggleExpanded()
					break
				case "launchApp":
					launchApp(onClickAppCommand)
					break
				case "disabled":
				default:
					break
			}
		}
	}

	// ------------------------------------------------------------------------------------------------------------------------

	PlasmaComponents.Label {
		id: clock
		Layout.alignment: Qt.AlignHCenter
		textFormat: Text.RichText
		// Always the full widget width, never just the width of the text. A
		// label narrower than the widget keeps the rich text document at the
		// width of the widest value it ever held, and then centres the text in
		// that stale width, which pushed the short values off to the right
		// [#166]. Spanning the widget keeps document and label the same width,
		// so the "align" of the layout markup decides, as it should.
		Layout.fillWidth: true
		Layout.fillHeight: widgetContainerFillHeight
		// Without this the clock sticks to the top edge as soon as the label is
		// taller than the text, which is exactly what "Container fill height"
		// does [#166].
		verticalAlignment: Text.AlignVCenter

		font.family: useCustomFont ? customFont.family : Qt.application.font.family
		font.pointSize: useCustomFont ? customFont.pointSize : Qt.application.font.pointSize
		font.bold: useCustomFont ? customFont.bold : Qt.application.font.bold
		font.italic: useCustomFont ? customFont.italic : Qt.application.font.italic
		font.underline: useCustomFont ? customFont.underline : Qt.application.font.underline
	}

	// ------------------------------------------------------------------------------------------------------------------------
	// Widget size stability [#166]
	//
	// The label is as wide as the HTML it renders, so every {cycle}/{random}
	// tick that swaps in a value of a different length resizes the whole
	// widget and pushes the neighbouring panel applets around. User markup
	// cannot prevent that: Qt's rich text ignores "width" on <div>/<body>, it
	// honours it on <table> only (see docs/tips.md).
	//
	// So updateClock() keeps the largest rendering seen so far and publishes
	// it as the widget minimum size: the widget grows, but never shrinks back
	// on the next tick. To have that size right from the first tick instead of
	// growing into it, the first tick after a reset also renders every {cycle}
	// variant into the invisible "sizer" label below.

	// Widest and tallest rendering seen since the last layout/font change.
	property real stableWidth: 0
	property real stableHeight: 0

	// In a vertical panel the width is dictated by the panel thickness, so
	// pinning it would push the clock out of the panel instead of stabilizing
	// it. There the height is the free axis, and the other way round.
	readonly property bool verticalPanel: Plasmoid.formFactor === PlasmaCore.Types.Vertical

	// Size the widget asks its container for: the clock as rendered now, never
	// less than the widest variant, then clamped by the user width limits.
	readonly property real requestedWidth: {
		var width = Math.max(clock.implicitWidth, stableWidth)
		if (enforceWidgetMinWidth) width = Math.max(width, widgetMinWidth)
		// A minimum above the user maximum would win over it, so clamp it.
		if (enforceWidgetMaxWidth) width = Math.min(width, widgetMaxWidth)
		return width
	}
	readonly property real requestedHeight: Math.max(clock.implicitHeight, stableHeight)

	// The panel picks an applet width from Layout.preferredWidth, falls back to
	// Layout.minimumWidth, and then to the panel thickness - see findPositive()
	// in plasma-desktop containments/panel/main.qml. Publishing no width hint
	// at all is what made a clock wider than the panel is thick overlap its
	// neighbours [#166], so the width goes out as the preferred one, with the
	// same value as minimum to keep the panel from shrinking it again.
	Layout.preferredWidth: verticalPanel ? -1 : requestedWidth
	Layout.minimumWidth: verticalPanel ? 0 : requestedWidth
	Layout.maximumWidth: (!verticalPanel && enforceWidgetMaxWidth)
			? widgetMaxWidth
			: Number.POSITIVE_INFINITY
	Layout.preferredHeight: verticalPanel ? requestedHeight : -1
	Layout.minimumHeight: verticalPanel ? requestedHeight : 0

	// Must stay explicit. This root is a ColumnLayout, and the Layout attached
	// property of a layout reports fillWidth/fillHeight as true unless told
	// otherwise. Plasma copies both onto the applet, where "true" tells the
	// panel the clock wants all the free space in it. The widget has its own
	// fill options for the label, and the panel thickness is already handled
	// by Plasmoid.constraintHints in main.qml.
	Layout.fillWidth: false
	Layout.fillHeight: false

	// The size hints have to be right before Plasma reads them, and the clock
	// timer only fires once the event loop runs, which is too late.
	Component.onCompleted: updateClock()

	// Invisible, so QtQuick layouts skip it, but it still reports the implicit
	// size of any HTML assigned to it. Mirrors the real label's font, or the
	// measurements would not match what the user sees.
	Text {
		id: sizer
		visible: false
		textFormat: Text.RichText
		font: clock.font
	}

	// Everything that changes how large the rendered clock is. Once any of it
	// changes, the widest-so-far size belongs to the old layout and has to be
	// measured again from scratch.
	readonly property string stableSizeKey: [
			layoutKey,
			useUserLayout,
			activeLayoutSlot,
			Plasmoid.configuration.layout,
			Plasmoid.configuration.layout2,
			Plasmoid.configuration.layout3,
			clock.font.family,
			clock.font.pointSize,
			clock.font.pixelSize,
			clock.font.bold,
			clock.font.italic,
			clock.font.underline,
			Plasmoid.configuration.useSpecificLocaleEnabled,
			Plasmoid.configuration.useSpecificLocaleLocaleName,
			Plasmoid.configuration.clockTimezoneOffsetEnabled,
			configTimezoneOffset,
		].join('|')

	onStableSizeKeyChanged: resetStableSize()

	function resetStableSize() {
		stableWidth = 0
		stableHeight = 0
		updateClock()
	}

	/*
	** Grows stableWidth/stableHeight so that they cover the clock as it is
	** rendered right now, and (once per reset) every variant the template can
	** cycle through.
	**
	** Arguments:
	**   layoutHtml: raw layout, with no placeholder expanded yet
	**       locale: locale to format dates with
	**     tzOffset: timezone offset in minutes, or null for local time
	*/
	function measureStableSize(layoutHtml, locale, tzOffset) {
		// The visible label is laid out already, so folding its size in is
		// free. It is also what makes the widget grow the moment a value
		// nothing could predict (a {random} pick, a longer month name) shows
		// up for the first time.
		var width = Math.max(stableWidth, clock.implicitWidth)
		var height = Math.max(stableHeight, clock.implicitHeight)

		// Rendering all the variants costs real time (~0.7ms each), and the
		// running maximum above learns them anyway after one full round of
		// {cycle}. It runs once, right after a reset, only so that the widget
		// has its final size from the very first tick instead of growing into
		// it over the next few seconds.
		if (stableWidth === 0) {
			var period = Placeholders.cyclePeriod(layoutHtml)
			for (var i = 0; i < period; i++) {
				var txt = Placeholders.expandFlip(layoutHtml, cycleIndex + i)
				txt = Placeholders.expandCycle(txt, cycleIndex + i)
				// Throwaway state, so measuring never disturbs the picks the
				// visible clock is showing right now.
				txt = Placeholders.expandRandom(txt, randomIndex, { picks: {}, lastIndex: -1 })
				sizer.text = DTF.format(txt, locale, tzOffset)
				width = Math.max(width, sizer.implicitWidth)
				height = Math.max(height, sizer.implicitHeight)
			}
		}

		stableWidth = width
		stableHeight = height
	}

	// The clock reads the time itself (DTF.format() calls new Date()), so this timer
	// is just the heartbeat. The time data engine used to do that job, but neither it
	// nor a plain 1000ms Timer aligns to the second boundary, so the clock lagged up
	// to a second behind other clocks [#162]. Recomputing the interval after every
	// tick pulls it back to the ".000" boundary, still at one wakeup per second.
	Timer {
		id: clockTimer
		interval: 1000
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			updateClock()
			interval = Utils.msToNextSecond()
		}
	}

	property string configTimezoneOffset: Plasmoid.configuration.clockTimezoneOffset

	function getActiveUserLayout() {
		switch (activeLayoutSlot) {
			case 2: return Plasmoid.configuration.layout2
			case 3: return Plasmoid.configuration.layout3
			default: return Plasmoid.configuration.layout
		}
	}

	function updateClock() {
		var layoutHtml = useUserLayout
				? getActiveUserLayout()
				: Layouts.layouts[layoutKey]['html']
		var localeToUse = Utils.configuredLocale(Plasmoid.configuration)
		var finalOffsetOrNull = Utils.configuredTzOffset(Plasmoid.configuration)
		var txt = layoutHtml
		txt = Placeholders.expandFlip(txt, cycleIndex)
		txt = Placeholders.expandCycle(txt, cycleIndex)
		txt = Placeholders.expandRandom(txt, randomIndex, randomState)
		clock.text = DTF.format(txt, localeToUse, finalOffsetOrNull)

		measureStableSize(layoutHtml, localeToUse, finalOffsetOrNull)
	}

	// ------------------------------------------------------------------------------------------------------------------------

} // mainContainer
