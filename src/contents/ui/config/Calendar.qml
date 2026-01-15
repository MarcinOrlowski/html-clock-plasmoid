/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2026 Marcin Orlowski
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

	property alias cfg_showWeekNumbers: showWeekNumbers.checked
	property string cfg_onClickAction: "calendar"
	property alias cfg_onClickAppCommand: appCommandField.text

	ComboBox {
		id: onClickActionCombo
		Kirigami.FormData.label: i18n("On click")
		model: [
			{ text: i18n("Show calendar"), value: "calendar" },
			{ text: i18n("Launch application"), value: "launchApp" },
			{ text: i18n("Do nothing"), value: "disabled" }
		]
		textRole: "text"
		currentIndex: {
			for (var i = 0; i < model.length; i++) {
				if (model[i].value === cfg_onClickAction) return i
			}
			return 0
		}
		onCurrentIndexChanged: {
			if (currentIndex >= 0) {
				cfg_onClickAction = model[currentIndex].value
			}
		}
	}

	TextField {
		id: appCommandField
		Kirigami.FormData.label: i18n("Command")
		visible: cfg_onClickAction === "launchApp"
		Layout.fillWidth: true
		placeholderText: i18n("e.g. kalendar, gnome-calendar")
	}

	CheckBox {
		id: showWeekNumbers
		visible: cfg_onClickAction === "calendar"
		text: i18n("Show week numbers")
	}

	Item {
		Layout.fillWidth: true
		Layout.fillHeight: true
	}

}
