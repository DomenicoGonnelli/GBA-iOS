//
//  DeviceManager.swift
//  Delta
//
//  Created by Domenico Gonnelli on 26/03/25.
//  Copyright © 2025 Riley Testut. All rights reserved.
//

import Foundation
import UIKit

class DeviceManager {
    
    static var group = "group.com.Domenico.Gonnelli.fonefantasy"
    
    static var currentDevice : DevicesType {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: // It's an iPhone
            return .phone
        case .pad: // It's an iPad (or macOS Catalyst)
            return .pad
        default:
            return .unspecified
        }
    }
    
    
    static var fontSize: CGFloat {
        switch currentDevice {
        case .pad:
            return 28
        default:
            return 18
        }
    }
    
    static func incrementNotificationCounter() -> Int {
        if let sharedDefaults = UserDefaults(suiteName: group) {
            let count = sharedDefaults.integer(forKey: "notificationCounter")
            sharedDefaults.set(count + 1, forKey: "notificationCounter")
            sharedDefaults.synchronize()
            return count+1
        }
        return 0
    }

    static func resetNotificationCounter() {
        if let sharedDefaults = UserDefaults(suiteName: group) {
            sharedDefaults.set(0, forKey: "notificationCounter")
            sharedDefaults.synchronize()
        }
    }
    
    public static func storeLang(lang: String){
        
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.appendingPathComponent("lang")
        if let fileURL = fileURL {
            do {
                try lang.write(to: fileURL, atomically: true, encoding: .utf8)
                print("stored language: \(lang)")
            } catch {
                print(error)
            }
        }
    }
    
    public static func getFirstLang() -> language?{
        do {
            guard let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.appendingPathComponent("lang") else {
                return nil
            }
            let data = try Data(contentsOf: fileURL)
            if let lang = String(data: data, encoding: .utf8) {
                return language(rawValue: lang)
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    
    public static func getLang() -> language{
        do {
            guard let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.appendingPathComponent("lang") else {
                return .en
            }
            let data = try Data(contentsOf: fileURL)
            if let lang = String(data: data, encoding: .utf8) {
                return language(rawValue: lang) ?? .en
            }
        } catch {
            print(error)
        }
        return .en
    }
    
    public static func getUserMail() -> String {
        if let sharedDefaults = UserDefaults(suiteName: group) {
            let messaggio = sharedDefaults.string(forKey: "userMail") ?? "null"
            return messaggio
        }
        return "null"
    }
    
    public static func getThemeLang() -> language{
        do {
            guard let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.appendingPathComponent("theme_lang") else {
                return getLang()
            }
            let data = try Data(contentsOf: fileURL)
            if let lang = String(data: data, encoding: .utf8) {
                return language(rawValue: lang) ?? getLang()
            }
        } catch {
            print(error)
        }
        return getLang()
    }
    
    public static func storeThemeLang(lang: String){
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group)?.appendingPathComponent("theme_lang")
        if let fileURL = fileURL {
            do {
                try lang.write(to: fileURL, atomically: true, encoding: .utf8)
                print("stored theme: \(lang)")
            } catch {
                print(error)
            }
        }
    }
    
    
}

enum DevicesType : Int {
    case unspecified
    case phone // iPhone and iPod touch style UI
    case pad   // iPad style UI (also includes macOS Catalyst)
}
