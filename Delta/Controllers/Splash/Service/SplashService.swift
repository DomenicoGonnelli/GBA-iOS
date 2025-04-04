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
                completion(user != nil)
            }
        }
    }
    
    static func getAppConfig(_ completion: @escaping (HomeServiceModel?)->Void){
        
        FirestoreHelper.getLinkStorage(){ links in
            
            
            let jsonUrl = AppManager.shared.links?.appConfig ?? "https://firebasestorage.googleapis.com/v0/b/sanremofantasy2024.appspot.com/o/Json%2F2025%2FappConfig.json?alt=media&token=efb4deb0-b640-4ff2-a07c-908d0814bd53"
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
