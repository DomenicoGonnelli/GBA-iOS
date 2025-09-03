//
//  UserModel.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import FirebaseFirestore
import UIKit

class UserModel : DatabaseModelProtocol{

    var id: String?
    var loginMode: LoginMode = .null
    var identificator: String? //mail
    var name: String?
    var imgLink: String?
    var registrationDate : Date?
    
    var premium : PremiumUser?
    
    var premiumSubscription: PremiumSubscriptionModel?{
        return AppManager.shared.premiumSubscriptions.first(where: {$0.iosKeyShort == premium?.iosKeyShort})
    }
    
    var premiumState: PremiumStatus {
        guard let premium = premium else {
            return .noPremium
        }
        
        if premium.isExpired {
            return .expired
        }
        
        if premium.isActive {
            return .active
        }
        
        return .noPremium
    }
    
    var isPremium : Bool {
        premiumState == .active
    }
    
    init(){}
    
    required init(value: [String : Any]) {
        if let value = value["loginMode"] as? String {
            let d = value.replacingOccurrences(of: "Login", with: "")
            loginMode = LoginMode(rawValue: d) ?? .null
        }
        
        identificator = value["email"] as? String
        imgLink = value["imgLink"] as? String
        
        if let val = value["name"] as? String {
            name = val
        }
        if let val = value["registrationDate"] as? String {
            registrationDate = Date(date: val)
        }
      
        let admin = identificator == "7h5grbsbz2@privaterelay.appleid.com"
    }

    var datafile: Dictionary<String, Any> {
        
        var returnData : [String : Any] = [
            "loginMode" : loginMode.rawValue
        ]
        
        if let identificator = identificator {
            returnData["email"] = identificator
        }
        
        if let imgLink = imgLink {
            returnData["imgLink"] = imgLink
        }
        if let name = name {
            returnData["name"] = name
        }
        
        if let registrationDate = registrationDate {
            returnData["registrationDate"] = registrationDate.jsonData()
        }
        return returnData
        
    }
}

public enum LoginMode: String{
    case apple, facebook, phone, google, null, twitter
    
    var image: UIImage?{
        var imageName = ""
        switch self {
        case .apple:
            imageName = "appleLogin"
        case .facebook:
            imageName = "facebookLogin"
        case .phone:
            imageName = "phoneLogin"
        case .google:
            imageName = "googleLogin"
        case .null:
            imageName = ""
        case .twitter:
            imageName = "TwitterLogin"
        }
        return UIImage(named: imageName)
    }
}



extension UserModel {
    
    func saveInJson(key: String){
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: DeviceManager.group)?.appendingPathComponent("\(key).json")
        if let fileURL = fileURL {
            do {
                try JSONSerialization.data(withJSONObject: self.datafile).write(to: fileURL)
            } catch {
                print(error)
            }
        }
    }
    
    static func readJson(key: String) -> UserModel?{
        do {
            guard let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: DeviceManager.group)?.appendingPathComponent("\(key).json")
            else {
                return nil
            }
            let data = try Data(contentsOf: fileURL)
            if let dictionary = try JSONSerialization.jsonObject(with: data) as? Dictionary<String,Any>{
                let returnValue = UserModel(value: dictionary)
                return returnValue
            }
        } catch {
            print(error)
            return nil
        }
        return nil
    }
}


class PremiumUser: DatabaseModelProtocol {
    
    var isActive: Bool {
        let date = Date()
        if let exp = expirationDate?.millisecondsSince1970 {
            return date.millisecondsSince1970 <= exp
        }
        return false
        
    }
    var iosKey: String?
    var registrationDate: Date?
    var isExpired: Bool {
        let date = Date()
        if let exp = expirationDate?.millisecondsSince1970 {
            return date.millisecondsSince1970 > exp
        }
        return iosKey != nil
    }
    
    var expirationDate: Date?
    var iosKeyShort: String?{
        return iosKey?.components(separatedBy: ".").last
    }
    
    required init(value: [String : Any]) {
    
        iosKey = value["iosKey"] as? String
        
        if let registrationDate = value["registrationDate"] as? String{
            self.registrationDate = Date(date: registrationDate)
        } else if let registrationDate = value["registrationDate"] as? Int{
            self.registrationDate = Date(milliseconds: registrationDate)
        }
        
        if let expirationDate = value["expirationDate"] as? String{
            self.expirationDate = Date(date: expirationDate)
        } else if let expirationDate = value["expirationDate"] as? Int{
            self.expirationDate = Date(milliseconds: expirationDate)
        }
        
    }
    
    var datafile: Dictionary<String, Any> {
        
        var returnData : [String : Any] = [:]
        
        if let registrationDate = registrationDate {
            returnData["registrationDate"] = registrationDate.jsonData()
        }
        
        if let expirationDate = expirationDate {
            returnData["expirationDate"] = expirationDate.jsonData()
        }
       
        if let iosKey = iosKey {
            returnData["iosKey"] = iosKey
        }
        
        return returnData
        
    }
}

public enum PremiumStatus: CaseIterable {
    case noPremium, expired, active
}
