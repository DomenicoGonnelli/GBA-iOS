//
//  AppStoreReviewManager.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import StoreKit

enum AppStoreReviewManager: String {
     
    case reviewWorthyActionCount, lastReviewRequestAppVersion

    static let minimumReviewWorthyActionCount = 3
    
    static func requestReviewIfAppropriate() {
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        var actionCount = defaults.integer(forKey: self.reviewWorthyActionCount.rawValue)
        
        // 3.
        actionCount += 1
        
        // 4.
        defaults.set(actionCount, forKey: self.reviewWorthyActionCount.rawValue)
        
        // 5.
        guard actionCount >= minimumReviewWorthyActionCount else {
            return
        }
        
        // 6.
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: self.lastReviewRequestAppVersion.rawValue)
        
        // 7.
        guard lastVersion == nil || lastVersion != currentVersion else {
            return
        }
        
        // 8.
        SKStoreReviewController.requestReview()
        
        // 9.
        defaults.set(0, forKey: self.reviewWorthyActionCount.rawValue)
        defaults.set(currentVersion, forKey: self.lastReviewRequestAppVersion.rawValue)
    }
    
    static func addReview(){
        
        if let productURL = AppManager.shared.appStoreURL{
            var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [
                URLQueryItem(name: "action", value: "write-review")
            ]
            guard let writeReviewURL = components?.url else {
                return
            }
            UIApplication.shared.open(writeReviewURL)
        }
    }
}

