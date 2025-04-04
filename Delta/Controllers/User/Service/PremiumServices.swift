//
//  PremiumServices.swift
//  Project
//
//  Created by Domenico Gonnelli on 21/01/25.
//

import Foundation

class PremiumServices {
    
    static func getAllPremium(_ completion: @escaping ([PremiumSubscriptionModel])->Void){
        
        let url = "https://www.dropbox.com/scl/fi/3orzf53xc9dflzdob3ak9/premiumConfig.json?rlkey=jt5p8fuo00rlwz6lk1lkdsi25&dl=1"
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
