//
//  PremiumSubscriptionModel.swift
//  Project
//
//  Created by Domenico Gonnelli on 21/01/25.
//

import Foundation

class PremiumSubscriptionModel: DatabaseModelProtocolGet{
    
    var subscriptionName: String?
    var subscriptionId: String?
    var periodMonth: Int = 1
    var alphaBg: Int = 20
    private var iosKey: String?
    var backgroundLink: String?
    var helmetLink: String?
    var period: String?
    var benefits: [PremiumBenefitModel] = []
    var subscriptionType: PremiumSubscriptionTypology = .always
    
    var iosKeyShort: String?{
        return iosKey?.components(separatedBy: ".").last
    }
    
    init(){}
    
    required init(value: [String : Any]) {
        
        let lg = DeviceManager.getLang().rawValue
        if let value = value["subscription_name"] as? String {
            subscriptionName = value
        }
        
        if let value = value["subscription_id"] as? String {
            subscriptionId = value
        }
        if let value = value["typology"] as? String {
            subscriptionType = PremiumSubscriptionTypology(rawValue: value) ?? .always
        }
        
        periodMonth = value["period_month"] as? Int ?? 1
        
        if let value = value["ios_key"] as? String{
            iosKey = value
        }
        
        if let value = value["alpha"] as? Int{
            alphaBg = value
        }
        
        if let value = value["background"] as? String{
            backgroundLink = value
        }
        if let value = value["driver_helmet"] as? String{
            helmetLink = value
        }
        
        benefits = []
        if let list = value["benefit"] as? [String:Any] {
            if let list_lg = list[lg] as? [Dictionary<String,Any>] {
                for item in list_lg{
                    benefits.append(PremiumBenefitModel(value: item))
                }
            }
        }
        
        if AppManager.shared.inReview {
            benefits = benefits.filter({$0.showReview})
        }
        
        if let list = value["period"] as? [String:Any] {
            period = list[lg] as? String  ?? ""
        }
    }

}

public class PremiumBenefitModel: DatabaseModelProtocolGet{
    
    var title: String?
    var decription: String?
    var image: String?
    var showReview: Bool = true
    
    required init(value: [String : Any]) {
        title = value["title"] as? String
        decription = value["decription"] as? String
        image = value["image"] as? String
        showReview = value["showReview"] as? Bool ?? true
    }
}

enum PremiumSubscriptionTypology: String, CaseIterable {
    case always, collaboration, momentary
}
