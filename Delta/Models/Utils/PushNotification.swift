//
//  PushNotification.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation

class PushNotification  {
    var title : String?
    var body : String?
    var action : PushAction?
    var entry : [PushMessageCustomDataEntry]?
    var date : Date?
    var inAppId : NotificationInApp?
    
    init(){}
    
    init(payload: [AnyHashable: Any]) {
        self.entry = []
        for key in PayloadKeys.allCases {
            if let title_ita = payload[key.rawValue] as? String{
                entry?.append(PushMessageCustomDataEntry(key: key.rawValue, value: title_ita))
            }
        }
        
        let lang = DeviceManager.getLang().rawValue
        
        let aps = payload["aps"] as? [String:Any]
        let alert = aps?["alert"] as? [String: Any]
        
        let originalTitle = alert?["title"] as? String ?? payload["title"] as? String
        let originalBody = alert?["body"] as? String ?? payload["body"] as? String
        
        
        title = entry?.first(where: {$0.key.contains("title_\(lang)")})?.value ?? originalTitle
        body = entry?.first(where: {$0.key.contains("body_\(lang)")})?.value ?? originalBody
        
        if let pushAction = entry?.first(where: {$0.key == PayloadKeys.pushAction.rawValue})?.value {
            action = PushAction(rawValue: pushAction) ?? PushAction.null
        }
        
        if let inAppId = payload["inAppId"] as? String{
            self.inAppId = NotificationInApp(rawValue: inAppId)
        }
        
        if let date = payload["date"] as? Int{
            self.date = Date(milliseconds: date)
        }
    }
    
    var dict: Dictionary<String, Any> {
        var returnDict = Dictionary<String,Any>()
        if let title = title {
            returnDict["title"] = title
        }
        if let body = body {
            returnDict["body"] = body
        }
        
        if let action = action?.rawValue {
            returnDict["pushAction"] = action
        }
        
        if let action = inAppId?.rawValue {
            returnDict["inAppId"] = action
        }
        
        if let date = date {
            returnDict["date"] = date.millisecondsSince1970
        } else {
            returnDict["date"] = Date().millisecondsSince1970
        }
        return returnDict
    }
    
    
    static func saveNotification(push: PushNotification){
        var list = getNotification()
        list.insert(push, at: 0)
        let token =  DeviceManager.getUserMail()
        list.dict.saveInJson(fileName: "push_\(token)")
    }
    
    
    
    static func getNotification() -> [PushNotification] {
        let token =  DeviceManager.getUserMail()
        print(token)
        let dict = Dictionary<String,Any>.readJson("push_\(token)")
        var list : [PushNotification] = []
        
        if let dictionary =  dict?["list"] as? [Dictionary<String,Any>]{
            for dic in dictionary {
                let push = PushNotification(payload: dic)
                list.append(push)
            }
        }
        return list
    }
               

}

extension Array where Element == PushNotification {
    
    var dict: Dictionary<String,Any>{
        var json : [Dictionary<String,Any>] = []
        for item in self {
            json.append(item.dict)
        }
        
        return ["list": json]
    }
    
    func saveNotification(){
        let token =  DeviceManager.getUserMail()
        self.dict.saveInJson(fileName: "push_\(token)")
    }
}


class PushMessageCustomDataEntry {
    
    var value : String
    var key : String
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}


enum PushAction : String, CaseIterable {
    case home, createTeam, userProfile, classification, lastEvening, voucher, null, openQuiz
    
}

enum PayloadKeys: String, CaseIterable {
    case title_it, body_it, title_es, body_es, title_en, body_en, title_zh, body_zh, title_ja, body_ja, title_pt, body_pt, title_ru, body_ru, pushAction
}

public enum language: String, CaseIterable {
    case it = "it"
    case es = "es"
    case en = "en"
    //case ja = "ja"
    case pt = "pt"
   // case zh = "zh"
   // case ru = "ru"
    case de = "de"
    case fr = "fr"
    
    static var list : [language] {
        
        var all = language.allCases
        let selectedLang = DeviceManager.getLang()
        
        all.removeAll(where: {$0 == selectedLang})
        all.insert(selectedLang, at: 3)
    
        return all
    }
    
    
    var name : String {
        
        switch self {
        case .it:
            "🇮🇹 Italiano"
        case .es:
            "🇪🇸 Español"
        case .en:
            "🇬🇧 English"
        case .pt:
            "🇵🇹 Português"
        case .de:
            "🇩🇪 Deutsch"
        case .fr:
            "🇫🇷 Français"
        }
    }
    
    var paletteName : String {
        return "\(self.rawValue)Palette"
    }
}
