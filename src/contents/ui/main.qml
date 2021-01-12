/**
 * HTML Clock Plasmoid
 *
 * Configurabler vertical multi clock plasmoid.
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2021 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.1
import org.kde.plasma.plasmoid 2.0

Item {
	id: main

	// ------------------------------------------------------------------------------------------------------------------------

	Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
	Plasmoid.compactRepresentation: HtmlClock { }

	// ------------------------------------------------------------------------------------------------------------------------

} // main
