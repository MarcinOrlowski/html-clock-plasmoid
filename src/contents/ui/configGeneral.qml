/**

 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2021 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kquickcontrols 2.0 as KQControls
import org.kde.plasma.components 3.0 as PlasmaComponents
import "../js/layouts.js" as Layouts

Kirigami.FormLayout {
	Layout.fillWidth: true

	property alias cfg_layoutKey: layoutKey.text
	property alias cfg_useUserLayout: useUserLayout.checked
	property alias cfg_useSpecificLocaleEnabled: useSpecificLocaleEnabled.checked
	property alias cfg_useSpecificLocaleLocaleName: useSpecificLocaleLocaleName.text
	property alias cfg_useCustomFont: useCustomFont.checked
	property alias cfg_customFont: fontSelector.selectedFont

	Text {
		visible: false
		id: layoutKey
	}

	PlasmaComponents.ComboBox {
		Kirigami.FormData.label: i18n('Layout')
		enabled: !cfg_useUserLayout
		textRole: "text"
		model: []
		Component.onCompleted: {
			// populate model from Theme object
			var tmp = []
			var idx = 0
			var currentIdx = undefined
			for(const key in Layouts.layouts) {
				var name = Layouts.layouts[key]['name']
				tmp.push({'value':key, 'text': name})
				if (key === plasmoid.configuration['layoutKey']) currentIdx = idx
				idx++
			}
			model = tmp

			currentIndex = currentIdx
		}
		onCurrentIndexChanged: cfg_layoutKey = model[currentIndex]['value']
	} // ComboBox

	PlasmaComponents.CheckBox {
		id: useUserLayout
		text: i18n("Use user layout")
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

		ConfigFontSelector {
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



} // FormLayout

