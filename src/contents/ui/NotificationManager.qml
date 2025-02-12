/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2023 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick
import org.kde.plasma.core as PlasmaCore

QtObject {
	id: notificationManager

	property var dataSource: PlasmaCore.DataSource {
		id: dataSource
		engine: "notifications"
		connectedSources: ["org.freedesktop.Notifications"]
	}

	function post(args) {
		// https://github.com/KDE/plasma-workspace/blob/master/dataengines/notifications/notifications.operations
		var service = dataSource.serviceForSource("notification")
		var operation = service.operationDescription("createNotification")
		operation.appName = args.title
		operation.appIcon = args.icon || ''
		operation.summary = args.summary || ''
		operation.body = args.body || ''
		if (typeof args.expireTimeout !== undefined) {
			operation.expireTimeout = args.expireTimeout
		}
		service.startOperationCall(operation)
	}
}
