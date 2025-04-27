//
//  NotificationManager.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import UserNotifications
import FirebaseMessaging
import AppTrackingTransparency
import UIKit

class NotificationManager : NSObject{
    
    static var shared: NotificationManager = NotificationManager()
    
    var delegate : NotificationPresenterDelegate?
    var fcmToken : String?
    var notificationToShow : PushNotification?
    var hasToShowNotification : Bool = false
    var isLoginRequired : Bool = false
    
    var notificationHandler : (() -> ())?{
        didSet{
            notificationHandler?()
        }
    }
    
    override init(){
        super.init()
        Messaging.messaging().delegate = self
    }
    
    fileprivate var application : UIApplication{
        return UIApplication.shared
    }
    
    func askNotificationPermission(){
        NotificationHelper.setNotificationAsked()
        register()
    }
    
    func registerToPushNotification(){
        UNUserNotificationCenter.current().delegate = self
        guard !NotificationHelper.notificationWasAsked() else {
            return
        }
        register()
    }
    
    private func register(){
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {(granted, error) in
            NotificationHelper.setPushPermissionAccepted(permission: granted)
            self.delegate?.userGrantedPermission(granted: granted, error: error)
            NotificationManager.shared.updateNotificationTokenService()
            NotificationHelper.setNotificationAsked()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization{ status in
                        print("Request tracking authorization status \(status.rawValue)")
                    }
                }
            }
        })
        
        DispatchQueue.main.async {
            self.application.registerForRemoteNotifications()
        }
        
    }
    
    func manageNotificationPayload(_ payload: [AnyHashable: Any]){
        print("NOTIFICATION_MANAGER PushReceived JSON --> \(payload.jsonStringRepresentation ?? "-")")
        let notification = PushNotification(payload: payload)
        notificationToShow = notification
        hasToShowNotification = true
        notificationHandler?()
    }
    
    func didReceiveNotificationToken(deviceToken: Data){
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
    }
    
    func updateNotificationTokenService(){
        if let token = self.fcmToken, NotificationHelper.notificationWasAsked(), NotificationHelper.fcmTokenSaved() != token && NotificationHelper.isPushPermissionAccepted(){
            print("NOTIFICATION_MANAGER --> FCMToken \(token)")
            
        }else{
            print("NOTIFICATION_MANAGER --> FCM Token update not needed")
        }
    }
    
    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Errore nella richiesta di autorizzazione: \(error.localizedDescription)")
            } else {
                print("Autorizzazione concessa: \(granted)")
            }
        }
    }
    
    func scheduleNotification(notification: NotificationInApp) {
        let content = UNMutableNotificationContent()
        content.title = notification.title.localizable
        content.body = notification.message.localizable
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Errore nell'aggiunta della notifica: \(error.localizedDescription)")
            } else {
                if notification != .accountDeleted && notification != .logoutSuccess{
                    PushNotification.saveNotification(push: notification.pushNotification)
                }
            }
        }
    }
    
}

extension NotificationManager : UNUserNotificationCenterDelegate{
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge,.banner, .list, .sound])
    }

    
    @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            switch response.actionIdentifier {
            case UNNotificationDismissActionIdentifier:
                print("Dismiss Action")
            case UNNotificationDefaultActionIdentifier:
                print("Open Action")
            case "Snooze":
                print("Snooze")
            case "Delete":
                print("Delete")
            default:
                print("default")
            }
            manageNotificationPayload(response.notification.request.content.userInfo)
            completionHandler()
        }
}

extension NotificationManager : MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {return}
        print("FCM messaging deviceToken \(fcmToken)")
        NotificationManager.shared.fcmToken = fcmToken
        updateNotificationTokenService()
    }
    
}

protocol NotificationPresenterDelegate{
    
    func userGrantedPermission(granted: Bool, error: Error?)
    
}
