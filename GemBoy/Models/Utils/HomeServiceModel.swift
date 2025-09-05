//
//  HomeServiceModel.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation

class HomeServiceModel : DatabaseModelProtocolGet{
    
    var baseUrlProd: String?
    var iosConfig: IOSConfig?
    var premiumConfig: PremiumConfig?
    var salesConfig: SalesConfig?
    init(){}
    
    func setValue(for value: [String : Any]) {
        
        if let baseUrlProd = value["baseUrl"] as? String{
            self.baseUrlProd = baseUrlProd
        } else if let url = value["baseUrlProd"] as? String{
            self.baseUrlProd = url
        }
    
        if let config = value["iOS"] as? [String:Any]{
            iosConfig = IOSConfig(value: config)
        }
        
        if let config = value["premium"] as? [String:Any]{
            premiumConfig = PremiumConfig(value: config)
        }
        
        if let config = value["premiumSales"] as? [String:Any]{
            salesConfig = SalesConfig(value: config)
        }
        
        
    }
    
    required init(value: [String : Any]) {
        if let data = value["configApp"] as? String,let json = data.toJSON() as? [String : Any]{
            setValue(for: json)
        } else {
            setValue(for: value)
        }
    }

    
}

class IOSConfig: DatabaseModelProtocolGet{
    
    var appName: String?
    var lastAppVersion: String?
    var versionForRequireUpdate: String?
    var GADid: String?
    var appStoreURL: String?
    var secretKey: String?
    var enableGDPR: Bool = false
    var maintenance: MaintenanceModel?
    var checkMode: Bool = false
    
    init(){}
    
    required init(value: [String : Any]) {
        lastAppVersion = value["lastAppVersion"] as? String
//        lastAppVersion = value["releasedAppVersion"] as? String
        appName = value["appNameNew"] as? String
        versionForRequireUpdate = value["versionForRequireUpdate"] as? String
        GADid = value["GADid_new"] as? String ?? value["GADid"] as? String
        appStoreURL = value["appStoreURL"] as? String
        secretKey = value["secretKey"] as? String
        checkMode = false// value["checkMode"] as? Bool ?? false
        if let values = value["maintenanceMode"] as? [String:Any]{
            maintenance = MaintenanceModel(value: values)
        }
        DeviceManager.appName = appName ?? ""
    }
}

class MaintenanceModel: DatabaseModelProtocolGet{
    var isActive: Bool = false
    var message: String?
    var title: String?
    
    init(){}
    
    required init(value: [String : Any]) {
        isActive = value["isActive"] as? Bool ?? false
        let lang = DeviceManager.getLang().rawValue
        
        if let message = value["message"] as? [String:Any] {
            self.message = message[lang] as? String
        }
        
        if let title = value["title"] as? [String:Any] {
            self.title = title[lang] as? String
        }
    }
}


class SalesConfig: DatabaseModelProtocolGet{
    
    var idSale: String?
    var startDate: Date?
    var endDate: Date?
    var imageLink: String?
    var animationLink: String?
    var message: String?
    var title: String?
    
    init(){}
    
    required init(value: [String : Any]) {
        if let date = value["startDateString"] as? String{
            startDate = Date(date: date)
        } 
        
        if let date = value["endDateString"] as? String{
            endDate = Date(date: date)
        }
        
        let lang = DeviceManager.getLang().rawValue
        if let message = value["message"] as? Dictionary<String,Any> {
            self.message = message[lang] as? String
        }
        
        if let title = value["title"] as? Dictionary<String,Any> {
            self.title = title[lang] as? String
        }
        
        imageLink = value["imageLink"] as? String
        animationLink = value["animationLink"] as? String
        idSale = value["idSale"] as? String
    }
}


class PremiumConfig: DatabaseModelProtocolGet{
    var expirationDate: Date?
    var showPremiumBonusExpiration: Bool = false
    var annualExpirationDate : Date?
    var premiumListId: [String]?
    
    
    init(){}
    
    required init(value: [String : Any]) {
        if let expirationDate = value["expirationDateString"] as? String {
            self.expirationDate = Date(date: expirationDate)
        }
        
        if let expirationDate = value["annualExpirationDateString"] as? String {
            self.annualExpirationDate = Date(date: expirationDate)
        }
        
        if let premiumData = value["premiumListId"] as? Dictionary<String, Any> {
            if let bundleID = Bundle.main.bundleIdentifier,  let ids = premiumData[bundleID] as? [String] {
                premiumListId = ids
            }
        }
        showPremiumBonusExpiration = value["showPremiumBonusExpiration"] as? Bool ?? false
    }
}
