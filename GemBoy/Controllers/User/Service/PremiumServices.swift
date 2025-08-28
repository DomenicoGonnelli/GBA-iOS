//
//  PremiumServices.swift
//  Project
//
//  Created by Domenico Gonnelli on 21/01/25.
//

import Foundation

class PremiumServices {
    
    static func getAllPremium(_ completion: @escaping ([PremiumSubscriptionModel])->Void){
        
        //"https://www.dropbox.com/scl/fi/ezdml6l77dgla5kfcu1m6/premiumConfig.json?rlkey=3rpsoqnb4u235tjefpywdpkf2&dl=1"
        let url = "https://firebasestorage.googleapis.com/v0/b/gemboyadvance-d0331.firebasestorage.app/o/service%2FpremiumCollaboration.json?alt=media&token=af163232-25b9-4f88-94bb-b5433ba480da"
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
