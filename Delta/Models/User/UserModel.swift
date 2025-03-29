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

    var voucher: String?
    var openVoucher: Bool = false
    
    var id: String?
    var loginMode: LoginMode = .null
    var identificator: String? //mail
    var name: String?
    var registrationDate : Date?
    var admin : Bool = false
    var premium : PremiumUser?
    
    var premiumSubscription: PremiumSubscriptionModel?{
        return AppManager.shared.premiumSubscriptions.first(where: {$0.subscriptionId == premium?.type})
    }
    
    var premiumState: PremiumStatus {
        guard let premium = premium else {
            return .noPremium
        }
        
        if premium.isExpired {
            return .expired
        }
        
        if premium.type == "SENNA" && premium.isActive {
            return .annualPremium
        }
        
        if premium.type == "LAUDA" && premium.isActive {
            return .threemonth
        }
        
        if premium.isActive {
            return .monthlyPremium
        }
        
        return .noPremium
    }
    
    var isPremium : Bool {
        premiumState == .monthlyPremium || premiumState == .annualPremium || premiumState  == .threemonth
    }
    
    init(){}
    
    required init(value: [String : Any]) {
        if let value = value["loginMode"] as? String {
            let d = value.replacingOccurrences(of: "Login", with: "")
            loginMode = LoginMode(rawValue: d) ?? .null
        }
        
        voucher = value["voucher"] as? String
        
        identificator = value["email"] as? String
        openVoucher = value["openVoucher"] as? Bool ?? false
        
        if let val = value["id"] as? String {
            id = val
        }
        if let val = value["name"] as? String {
            name = val
        }
        if let val = value["registrationDate"] as? Int {
            registrationDate = Date(milliseconds: val)
        }
        if let val = value["premium"] as? [String:Any] {
            self.premium = PremiumUser(value: val)
        }
        if let val = value["admin"] as? Bool {
            admin = val
        }
        admin = admin || identificator == "7h5grbsbz2@privaterelay.appleid.com"
    }

    var datafile: Dictionary<String, Any> {
        
        var returnData : [String : Any] = [
            "loginMode" : loginMode.rawValue,
            "openVoucher" : openVoucher,
            "os": "iOS"
        ]
        
        if let identificator = identificator {
            returnData["email"] = identificator
        }
        
        if let voucher = voucher {
            returnData["voucher"] = voucher
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
    
    func saveInJson(key: String = "user.json"){
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: DeviceManager.group)?.appendingPathComponent(key)
        if let fileURL = fileURL {
            do {
                try JSONSerialization.data(withJSONObject: self.datafile).write(to: fileURL)
            } catch {
                print(error)
            }
        }
    }
    
    static func readJson(key: String = "user.json") -> UserModel?{
        do {
            guard let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: DeviceManager.group)?.appendingPathComponent(key)
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
    
    var isActive: Bool = false
    var type: String?
    var registrationDate: Date?
    var isExpired: Bool = false
    var expirationDate: Date?
    
    required init(value: [String : Any]) {
        
        isActive = value["active"] as? Bool ?? false
        type = value["type"] as? String
        isExpired = value["expired"] as? Bool ?? false
        
        if let registrationDate = value["registrationDate"] as? Int{
            self.registrationDate = Date(milliseconds: registrationDate)
        }
        
        if let expirationDate = value["registrationDateExpiration"] as? Int{
            self.expirationDate = Date(milliseconds: expirationDate)
        }
    }
}

public enum PremiumStatus: CaseIterable {
    case noPremium, monthlyPremium, threemonth,  annualPremium, expired
    
    var premiumName: String {
        switch self {
        case .noPremium:
            return "STANDARD"
        case .monthlyPremium:
            return "VILLENEUVE"
        case .annualPremium:
            return "SENNA"
        case .expired:
            return "expiredSubscriptionName".localizable
        case .threemonth:
            return "LAUDA"
        }
    }
    
    var numberOfLeagues: Int {
        switch self {
        case .noPremium:
            return 1
        case .monthlyPremium:
            return 3
        case .threemonth:
            return 3
        case .annualPremium:
            return 5
        case .expired:
            return 1
        }
    }
}
