//
//  NotificationHelper.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import FirebaseMessaging

class NotificationHelper{
    
    private static let keyNotificationAsked = "kNotificationAsked_2"
    private static let keyNotificationFcmToken = "kNotificationFcmToken"
    private static let keyNotificationUserPermission = "kNotificationUserPermission"
    
    static func notificationWasAsked() -> Bool{
        return UserDefaults.standard.bool(forKey: keyNotificationAsked)
    }
    
    static func setNotificationAsked(asked: Bool = true){
        UserDefaults.standard.set(asked, forKey: keyNotificationAsked)
    }
    
    static func fcmTokenSaved() -> String{
        return UserDefaults.standard.string(forKey: keyNotificationFcmToken) ?? "NotAllowed"
    }
    
    static func saveFcmToken(fcmToken: String){
       if fcmToken != ""{
            UserDefaults.standard.set(fcmToken, forKey: keyNotificationFcmToken)
        }
    }
    
    static func isPushPermissionAccepted() -> Bool{
        return UserDefaults.standard.bool(forKey: keyNotificationUserPermission)
    }
    
    static func setPushPermissionAccepted(permission: Bool){
        UserDefaults.standard.set(permission, forKey: keyNotificationUserPermission)
    }
    
    static func registerToTopic(topic: Topics, concat: [String] = []){
        
        var key = topic.rawValue
        
        for concatenation in concat {
            key.append("_\(concatenation)")
        }
        
        Messaging.messaging().subscribe(toTopic: key)
    }
    static func unregisterToTopic(topic: Topics, concat: [String] = []){
        var key = topic.rawValue
        
        for concatenation in concat {
            key.append("_\(concatenation)")
        }
        
        Messaging.messaging().unsubscribe(fromTopic:key)
    }
    
}


enum Topics: String, CaseIterable{
    case iOS
    case teamCreated
    case teamNotCreated
    case premiumUser
    
}
