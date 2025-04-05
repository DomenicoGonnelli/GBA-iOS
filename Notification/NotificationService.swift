//
//  NotificationService.swift
//  Notification
//
//  Created by Domenico Gonnelli on 26/03/25.
//  Copyright © 2025 Riley Testut. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        let notification =  PushNotification(payload:  request.content.userInfo)
        PushNotification.saveNotification(push: notification)
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = notification.title ?? bestAttemptContent.title
            bestAttemptContent.body = notification.body ?? bestAttemptContent.body
            bestAttemptContent.badge = (DeviceManager.incrementNotificationCounter()) as NSNumber
            contentHandler(bestAttemptContent)
        } else {
            let content = request.content
            contentHandler(content)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }


}
