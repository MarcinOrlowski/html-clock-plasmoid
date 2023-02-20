/**

 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2023 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kquickcontrols 2.0 as KQControls
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import "../../js/layouts.js" as Layouts
import "../lib"

Kirigami.FormLayout {
	Layout.fillWidth: true

	property alias cfg_layoutKey: layoutSelector.selectedLayoutKey
	property alias cfg_useUserLayout: useUserLayout.checked
	property alias cfg_useSpecificLocaleEnabled: useSpecificLocaleEnabled.checked
	property alias cfg_useSpecificLocaleLocaleName: useSpecificLocaleLocaleName.text
	property alias cfg_useCustomFont: useCustomFont.checked
	property alias cfg_customFont: fontSelector.selectedFont
	property alias cfg_transparentBackgroundEnabled: transparentBackground.checked

	property alias cfg_clockTimezoneOffsetEnabled: clockTimezoneOffsetEnabled.checked
	property alias cfg_clockTimezoneOffset: clockTimezoneOffset.text
	property alias cfg_widgetContainerFillWidth: widgetContainerFillWidth.checked
	property alias cfg_widgetContainerFillHeight: widgetContainerFillHeight.checked

	LayoutSelector {
		id: layoutSelector
		enabled: !cfg_useUserLayout
		Kirigami.FormData.label: i18n('Layout')
	}

	PlasmaComponents.CheckBox {
		id: useUserLayout
		text: i18n("Use user layout")
	}

	CheckBox {
		id: transparentBackground
		text: i18n("Transparent background")
		checked: cfg_transparentBackgroundEnabled

		// If ConfigurableBackground is set, the we most likely run on Plasma 5.19+ and if so,
		// we prefer using widget's background control features instead.
		visible: typeof PlasmaCore.Types.ConfigurableBackground === "undefined"
	}

	Item {
		height: 10
	}

	PlasmaComponents.CheckBox {
		id: useCustomFont
		text: i18n("Use custom font")
	}
	RowLayout {
		enabled: cfg_useCustomFont

		ColumnLayout {
			PlasmaComponents.Label {
				text: i18n('Font: %1', cfg_customFont.family)
			}
			PlasmaComponents.Label {
				text: i18n('Size: %1', cfg_customFont.pointSize)
			}
		}

		FontSelector {
			id: fontSelector
		}
	}

	Item {
		height: 10
	}

	RowLayout {
		CheckBox {
			id: useSpecificLocaleEnabled
			text: i18n("Locale to use")
		}

		TextField {
			id: useSpecificLocaleLocaleName
			enabled: cfg_useSpecificLocaleEnabled
		}
	}

	RowLayout {
		CheckBox {
			id: clockTimezoneOffsetEnabled
			text: i18n("Timezone offset")
		}

		TextField {
			id: clockTimezoneOffset
			enabled: cfg_clockTimezoneOffsetEnabled
		}
	}
	PlasmaComponents.CheckBox {
		id: widgetContainerFillWidth
		text: i18n("Container fill width")
	}
	PlasmaComponents.CheckBox {
		id: widgetContainerFillHeight
		text: i18n("Container fill height")
	}


} // FormLayout

