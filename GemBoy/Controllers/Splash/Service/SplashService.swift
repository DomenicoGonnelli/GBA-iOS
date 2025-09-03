//
//  SplashService.swift
//  Project
//
//  Created by EGONNEDGJ on 16/02/23.
//

import Foundation
import FirebaseAuth

class SplashService {
    static func autologin(_ completion: @escaping (Bool)->Void){
        if AppManager.shared.offlineMode {
            if let id = LoginManager.storedUID {
                completion(true)
            } else {
                completion(false)
            }
        } else {
            FirestoreHelper.getUserData(){ user in
                LoginManager.shared.user = user
                
                FirestoreHelper.getPremiumrData(){ premium in
                    LoginManager.shared.user?.premium = premium
                    completion(user != nil)
                }
            }
        }
    }
    
    static func getWhatNews(_ completion: @escaping ([OnBoardingGenericItem])->Void){
        
        ServiceHelper.instance.driveService(url: EnvHelper.whatNewsLink, request: nil, method: .get) { resp in
            if let resp = resp?["list"] as? [Dictionary<String,Any>] {
                var list : [OnBoardingGenericItem] = []
                
                let actual = AppManager.whatNewsVersion ?? "1.0"
                for i in resp {
                    list.append(OnBoardingGenericItem(value: i))
                }
                let filtered = list.filter({
                    if let version = $0.version  {
                        return actual.compare(version, options: .numeric) == .orderedAscending
                    }
                    return false
                })
                completion(filtered)
            } else {
                completion([])
            }
        }
        
    }
    
    static func getAppConfig(_ completion: @escaping (HomeServiceModel?)->Void){
        
        FirestoreHelper.getLinkStorage(){ links in
            let jsonUrl = AppManager.shared.links?.appConfig ?? "https://www.dropbox.com/scl/fi/xd73zfiyo8nuxpgl8qp3b/appConfig.json?rlkey=ag9r993y84hswt4pjijcqkrp3&dl=1"
            ServiceHelper.instance.driveService(url: jsonUrl, request: nil, method: .get) { resp in
                if let resp = resp {
                    let homeConfig = HomeServiceModel(value: resp)
                    completion(homeConfig)
                } else {
                    StorageHelper.getJson(service: "appConfig") { resp in
                        if let resp = resp {
                            let homeConfig = HomeServiceModel(value: resp)
                            completion(homeConfig)
                        } else {
                            completion (nil)
                        }
                    }
                }
            }
        }
    }
}
