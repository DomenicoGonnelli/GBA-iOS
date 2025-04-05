//
//  PremiumServices.swift
//  Project
//
//  Created by Domenico Gonnelli on 21/01/25.
//

import Foundation

class PremiumServices {
    
    static func getAllPremium(_ completion: @escaping ([PremiumSubscriptionModel])->Void){
        
        let url = "https://www.dropbox.com/scl/fi/ezdml6l77dgla5kfcu1m6/premiumConfig.json?rlkey=3rpsoqnb4u235tjefpywdpkf2&dl=1"
        ServiceHelper.instance.driveService(url: url, request: nil, method: .get){ response in
            var list = [PremiumSubscriptionModel]()
            if let items = response?["premiumObject"] as? [Dictionary<String,Any>] {
                for item in items {
                    list.append(PremiumSubscriptionModel(value: item))
                }
            }
            AppManager.shared.premiumSubscriptions = list
            completion(list)
        }
    }
    
}
