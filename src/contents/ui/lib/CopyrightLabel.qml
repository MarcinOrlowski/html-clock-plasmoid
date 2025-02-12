/**
 * Weekday Grid widget for KDE
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2023 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/weekday-plasmoid
 */

import QtQuick
import "../../js/meta.js" as Meta

ClickableLabel {
	url: Meta.authorUrl
	text: {
		var currentYear = new Date().getFullYear()
		var year='' + Meta.firstReleaseYear
		if (Meta.firstReleaseYear < currentYear) {
			year += '-' + currentYear
		}

		return '&copy;' + year + ' by <strong><u>' + Meta.authorName + '</u></strong>'
	}
}
