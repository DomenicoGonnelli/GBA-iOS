//
//  NotificationInApp.swift
//  Project
//
//  Created by Domenico Gonnelli on 31/01/25.
//

import Foundation

enum NotificationInApp: String {
    case teamCreated
    case teamUpdated
    case teamDeleted
    case paymentOk
    case subscritionSuccess
    case subscritionExpiring
    case subscritionExpired
    case accountDeleted
    case logoutSuccess
    case leagueCreated
    case leagueAdded
    case imageUpdated
    case guessPodiumUpdated
    case codeFounded
    case newFriend
    case newConfiguration
    
    var title: String {
        return "\(rawValue)NotificationTitle"
    }
    
    var message: String {
        return "\(rawValue)NotificationMessage"
    }
    
    var pushNotification: PushNotification{
        let push = PushNotification()
        push.title = self.title.localizable
        push.body = self.message.localizable
        push.inAppId = self
        return push
    }

    
}
