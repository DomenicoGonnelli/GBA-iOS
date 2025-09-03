//
//  PremiumServices.swift
//  Project
//
//  Created by Domenico Gonnelli on 21/01/25.
//

import Foundation

class PremiumServices {
    
    static func getAllPremium(_ completion: @escaping ([PremiumSubscriptionModel])->Void){
        
        let url = "https://www.dropbox.com/scl/fi/kc5sw9iub7m1wnubv6jy3/premiumCollaboration.json?rlkey=v3m5smo4uktsloy9xo8rhf9jz&dl=1"
        //let url = "https://firebasestorage.googleapis.com/v0/b/gemboyadvance-d0331.firebasestorage.app/o/service%2FpremiumCollaboration.json?alt=media&token=af163232-25b9-4f88-94bb-b5433ba480da"
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
