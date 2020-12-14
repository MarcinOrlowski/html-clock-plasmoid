/**
 * HTML Clock Plasmoid
 *
 * Configurabler vertical multi clock plasmoid.
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

ColumnLayout {
	id: mainContainer

	Layout.fillWidth: true

    // ------------------------------------------------------------------------------------------------------------------------

	function pad(str, len) {
		if (len === undefined) len = 2
		len = len * -1
		return ('0000000' + str).substr(len)
	}

	function format(template) {
		var map = {}
		var now = new Date()

		// https://doc.qt.io/qt-5/qml-qtqml-qt.html#formatDateTime-method
		map['yy'] = Qt.formatDate(now, 'yyyy')
		map['y'] = Qt.formatDate(now, 'yy')
		map['MMM'] = Qt.formatDate(now, 'MMMM')
		map['MM'] = Qt.formatDate(now, 'MMM')
		map['M'] = map['MM'].substr(0, 1)
		map['mm'] = Qt.formatDate(now, 'MM')
		map['m'] = Qt.formatDate(now, 'M')
		map['DDD'] = Qt.formatDate(now, 'dddd')
		map['DD'] = Qt.formatDate(now, 'ddd')
		map['D'] = map['DD'].substr(0, 1)
		map['dd'] = Qt.formatDate(now, 'dd')
		map['d'] = Qt.formatDate(now, 'd')
//		dy
//		dw
//		wm
//		wy
		map['hh'] = pad(now.getHours())
		map['h'] = now.getHours()
		map['kk'] = pad(now.getHours()%12)
		map['k'] = now.getHours()
		map['ii'] = pad(now.getMinutes())
		map['i'] = now.getMinutes()
		map['AA'] = Qt.formatTime(now, 'AP')
		map['A'] = map['AA'].substr(0, 1)
		map['aa'] = map['AA'].toLowerCase()
		map['a'] = map['aa'].substr(0, 1)
		map['Aa'] = map['A'] + map['aa'].substr(-1)

		map['t'] = Qt.formatTime(now, 't')

		for(var key in map) {
			template = template.replace(new RegExp(`%${key}%`, 'g'), map[key])
		}

		return template
	}
	
	PlasmaComponents.Label {
		id: clock
		Layout.fillWidth: true
		Layout.alignment: Qt.AlignHCenter
		textFormat: Text.RichText
		font.pixelSize: 20  //Qt.application.font.pixelSize * 0.8
	}

   	Timer {
		interval: 1000
		repeat: true
		running: true
		triggeredOnStart: true

		// https://doc.qt.io/qt-5/qml-qtquick-text.html#textFormat-prop
		// https://doc.qt.io/qt-5/richtext-html-subset.html
		onTriggered: {
			clock.text = format('
<center>
<span style="font-size: 30px; color: white;">%hh%</span>
<span style="font-size: 25px; color: #79808d;">:</span>
<span style="font-size: 35px; font-weight: bold; color: #ff006e;">%ii%</span>
<br>
<span style="font-size: 20px; text-transform: uppercase">%DDD%</span>
<br>
<span style="font-size: 15px; text-transform: uppercase">%yy%-%M%(%mm%)-%dd%</span>
</center>
')
		}
	}

	// ------------------------------------------------------------------------------------------------------------------------

} // mainContainer
