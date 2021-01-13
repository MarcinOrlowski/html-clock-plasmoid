/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2021 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.1
//import QtQuick.Layouts 1.1
//import QtQuick.Controls 2.3
import "../js/meta.js" as Meta

ClickableLabel {
	url: Meta.authorUrl
	text: {
		var currentYear = new Date().getFullYear()
		var year=`${Meta.firstReleaseYear}`
		if (Meta.firstReleaseYear < currentYear) {
			year += `-${currentYear}`
		}

		return `&copy;${year} by <strong><u>${Meta.authorName}</u></strong>`
	}
}
