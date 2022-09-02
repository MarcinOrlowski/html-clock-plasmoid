/**
 * Weekday Grid widget for KDE
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2022 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/weekday-plasmoid
 */

import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

Button {
	// There seems to be a bug in FontDialog that causes "font" property to
	// act as "selectedFont" which means both are updated immediately while
	// "font" is documented to be updated only once selection is Accepted,
	// so I had to add "proxy" property to work that around.
	property font selectedFont: theme.defaultFont

	text: i18n("Select font")
	onClicked: customFontDialog.open()
	FontDialog {
		id: customFontDialog
		onAccepted: selectedFont = font
		Component.onCompleted: font = selectedFont
	}
}

