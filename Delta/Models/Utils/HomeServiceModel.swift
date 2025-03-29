//
//  HomeServiceModel.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation

class HomeServiceModel : DatabaseModelProtocol{
    
    var baseUrlProd: String?
    var baseUrlCollaudo: String?
    var forceHttp: Bool = false
    var iosConfig: IOSConfig?
    var rulesLink: String?
    var rulesReviewLink: String?
    var rankingConfig: RankingConfig?
    var eventsConfig: EventsConfig?
    var teamConfig: TeamConfig?
    var quizConfig: QuizConfig?
    var liveConfig: LiveConfig?
    var newsConfig: LiveConfig?
    var socialConfig: SocialConfig?
    var wallet: WalletItem?
    var premiumConfig: PremiumConfig?
    var salesConfig: SalesConfig?
    init(){}
    
    func setValue(for value: [String : Any]) {
        
        if let baseUrlProd = value["baseUrl"] as? String{
            self.baseUrlProd = baseUrlProd
        } else if let url = value["baseUrlProd"] as? String{
            self.baseUrlProd = url
        }
        
        if let baseUrlCollaudo = value["baseUrlCollaudo"] as? String{
            self.baseUrlCollaudo = baseUrlCollaudo
        } else if let url = value["baseUrl"] as? String{
            self.baseUrlCollaudo = url
        }
        
        if let reg = value["regulation"] as? [String:Any]{
            let lang = DeviceManager.getLang().rawValue
            rulesLink = reg[lang] as? String ?? "https://dl.dropbox.com/scl/fi/33725e709hazdgqu3i369/es.html?rlkey=zluictfvje8nybw5pwh1x20m1&dl=0"
        }
        
        if let reg = value["regulationForReview"] as? [String:Any]{
            let lang = DeviceManager.getLang().rawValue
            rulesReviewLink = reg[lang] as? String ?? "https://dl.dropbox.com/scl/fi/33725e709hazdgqu3i369/es.html?rlkey=zluictfvje8nybw5pwh1x20m1&dl=0"
        }

        
        if let config = value["iOS"] as? [String:Any]{
            iosConfig = IOSConfig(value: config)
        }
        
        if let config = value["ranking"] as? [String:Any]{
            rankingConfig = RankingConfig(value: config)
        }
        
        if let config = value["events"] as? [String:Any]{
            eventsConfig = EventsConfig(value: config)
        }
        
        if let config = value["team"] as? [String:Any]{
            teamConfig = TeamConfig(value: config)
        }
        
        if let config = value["quiz"] as? [String:Any]{
            quizConfig = QuizConfig(value: config)
        }
        
        if let config = value["social"] as? [String:Any]{
            socialConfig = SocialConfig(value: config)
        }
        
        if let config = value["live"] as? [String:Any]{
            liveConfig = LiveConfig(value: config)
        }
        if let config = value["news"] as? [String:Any]{
            newsConfig = LiveConfig(value: config)
        }
        if let config = value["wallet"] as? [String:Any]{
            wallet = WalletItem(value: config)
        }
        if let config = value["premium"] as? [String:Any]{
            premiumConfig = PremiumConfig(value: config)
        }
        
        //premiumConfig = PremiumConfig(value: [
           // "expirationDateString": "05/11/2024",
            //"showPremiumBonusExpiration": true,
            //"annualExpirationDate": "31/12/2024"])
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

class IOSConfig: DatabaseModelProtocol{
    
    var appName: String?
    var lastAppVersion: String?
    var versionForRequireUpdate: String?
    var GADid: String?
    var appStoreURL: String?
    var secretKey: String?
    var enableGDPR: Bool = false
    var maintenance: MaintenanceModel?
    
    init(){}
    
    required init(value: [String : Any]) {
        lastAppVersion = value["lastAppVersion"] as? String
        appName = value["appName"] as? String
        versionForRequireUpdate = value["versionForRequireUpdate"] as? String
        GADid = value["GADid_Davide"] as? String
        appStoreURL = value["appStoreURL"] as? String
        secretKey = value["secretKey"] as? String
        if let values = value["maintenanceMode"] as? [String:Any]{
            maintenance = MaintenanceModel(value: values)
        }
    }
}

class MaintenanceModel: DatabaseModelProtocol{
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


class SalesConfig: DatabaseModelProtocol{
    
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

class RankingConfig: DatabaseModelProtocol{
    var isRankingEnabled: Bool = false
    var classificationShowedTeam: Int = 1000
    
    init(){}
    
    required init(value: [String : Any]) {
        isRankingEnabled = value["isRankingEnabled"] as? Bool ?? false
        classificationShowedTeam = value["classificationShowedTeam"] as? Int ?? 1000
    }
}

class SocialConfig: DatabaseModelProtocol{
    var isInstagramEnabled: Bool = false
    var instagramUrl: String?
    var instagramPageName: String?
    var webUrl: String?
    
    init(){}
    
    required init(value: [String : Any]) {
        isInstagramEnabled = value["isInstagramEnabled"] as? Bool ?? false
        webUrl = value["webUrl"] as? String
        instagramUrl = value["instagramUrl"] as? String
        instagramPageName = value["instagramPageName"] as? String
    }
}

class EventsConfig: DatabaseModelProtocol{
    var isEventsEnabled: Bool = false
    var isChampionshipEnded: Bool = false
    var startDate: Date?
    
    init(){}
    
    required init(value: [String : Any]) {
        isEventsEnabled = value["isEventsEnabled"] as? Bool ?? false
        isChampionshipEnded = value["isChampionshipEnded"] as? Bool ?? false
        if let startDateValue =  value["startDateString"] as? String {
            self.startDate = Date(date: startDateValue)
        }
        
    }
}

class TeamConfig: DatabaseModelProtocol{
    var enableChangeTeam: Bool = false
    var fantaMoney: Int = 1000
    var teamMember: Int = 10
    var startTime: Date?
    var endTime: Date?
    
    
    init(){}
    
    required init(value: [String : Any]) {
        enableChangeTeam = value["enableChangeTeam"] as? Bool ?? false
        fantaMoney = value["fantaMoney"] as? Int ?? 1000
        teamMember = value["teamMember"] as? Int ?? 10
        
        if let startTime = value["startTimeString"] as? String{
            self.startTime = Date(date: startTime)
        }
        
        if let endTime = value["endTimeString"] as? String{
            self.endTime = Date(date: endTime)
        }
    }
}

class QuizConfig: DatabaseModelProtocol{
    var isEnabled: Bool = false
    var isRankingEnabled: Bool = false
    
    init(){}
    
    required init(value: [String : Any]) {
        isEnabled = value["isEnabled"] as? Bool ?? false
        isRankingEnabled = value["isRankingEnabled"] as? Bool ?? false
    }
}

class PremiumConfig: DatabaseModelProtocol{
    var expirationDate: Date?
    var showPremiumBonusExpiration: Bool = false
    var annualExpirationDate : Date?
    
    init(){}
    
    required init(value: [String : Any]) {
        if let expirationDate = value["expirationDateString"] as? String {
            self.expirationDate = Date(date: expirationDate)
        }
        
        if let expirationDate = value["annualExpirationDateString"] as? String {
            self.annualExpirationDate = Date(date: expirationDate)
        }
        showPremiumBonusExpiration = value["showPremiumBonusExpiration"] as? Bool ?? false
    }
}

class LiveConfig: DatabaseModelProtocol{
    var isEnabled: Bool = false
    var url: String?
    
    init(){}
    
    required init(value: [String : Any]) {
        isEnabled = value["isEnabled"] as? Bool ?? false
        url = value["url"] as? String
    }
}


class GiftConfig: DatabaseModelProtocol{
    var showGift: Bool = false
    var firstPrize: Int?
    var secondPrize: Int?
    var thirdPrize: Int?
    var otherPrize: Int?
    
    init(){}
    
    required init(value: [String : Any]) {
        showGift = value["showGift"] as? Bool ?? false
        firstPrize = value["firstPrize"] as? Int
        secondPrize = value["secondPrize"] as? Int
        thirdPrize = value["thirdPrize"] as? Int
        otherPrize = value["otherPrize"] as? Int
    }
}

public class WalletItem: DatabaseModelProtocol {
    var showWallet : Bool = false{
        didSet{
            print("showWallet: \(showWallet)")
        }
    }
    var showBonusAnimation : Bool = false
    var limitBoundsForRequireVoucher : Int = 50
    var numberOfVouchers : Int = 0
    var expiringDate : Date?
    private var amazonPartnersLink : String?
    
    var amazonPartnersURL: URL? {
        guard let amazonPartnersLink = amazonPartnersLink else {
            return nil
        }
        return URL(string: amazonPartnersLink)
    }
    
    required init(value: [String : Any]) {
        showWallet = value["showWallet"] as? Bool ?? false
        showBonusAnimation = value["showBonusAnimation"] as? Bool ?? false
        limitBoundsForRequireVoucher = value["limitBoundsForRequireVoucher"] as? Int ?? 50
        numberOfVouchers = value["numberOfVouchers"] as? Int ?? 0
        amazonPartnersLink = value["amazonPartnersLink"] as? String
        if let expiringDate = value["expiringDateString"] as? String{
            self.expiringDate = Date(date: expiringDate)
        } else if let expiringDate = value["expiringDate"] as? Int{
            self.expiringDate = Date(milliseconds: expiringDate)
        }
    }
}
