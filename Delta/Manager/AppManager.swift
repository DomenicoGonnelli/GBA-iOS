//
//  AppManager.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import UIKit
import StoreKit

class AppManager {
    
    static var shared: AppManager = AppManager()
    
    var actualAppVersion : String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    var lang: language{
        DeviceManager.getLang()
    }
    var appName : String{
        return ""// homeData?.iosConfig?.appName ?? "Gemboy Advance"
    }
    
//    var homeData: HomeServiceModel?
    
    var appStoreURL: URL? {
        return nil// URL(string: homeData?.iosConfig?.appStoreURL ?? "")
    }
    
    var premiumExpired = false

    var premiumSubscriptions: [PremiumSubscriptionModel] = []
    
    func retrieveProduct(completion: @escaping ((Bool)->Void)){
        DispatchQueue(label: "background").async {
            autoreleasepool {
                IAPProduct.store.requestProducts{ [weak self] success, products in
                    guard let self = self else { return }
                    if success, let prod = products {
                        self.products = prod
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    var GADID: String {
        return ""// homeData?.iosConfig?.GADid ?? "ca-app-pub-8207452024525594/8651011980"
    }
    

    var products : [SKProduct] = []
    
    var premiumProduct: SKProduct?{
        return getProduct(productId: IAPProduct.premiumMonthly.rawValue)
    }
    var premiumProductAnnual: SKProduct?{
        return getProduct(productId: IAPProduct.premiumAnnual.rawValue)
    }
    
    func getProduct(productId: String) -> SKProduct? {
        return AppManager.shared.products.first(where: {$0.productIdentifier == productId})
    }
    
    var premiumProductPrize : String?{
        if let productPrice = premiumProduct?.price, let textPrice = IAPHelper.priceFormatter.string(from: productPrice) {
            return textPrice
        }
        return nil
    }
    var annualProductPrize : String?{
        if let productPrice = premiumProductAnnual?.price, let textPrice = IAPHelper.priceFormatter.string(from: productPrice) {
            return textPrice
        }
        return nil
    }
    
    var premiumProductPrizeAllMonth : String?{
        if let productPrice = premiumProduct?.price {
            let textPrice = productPrice.doubleValue * 9
            return IAPHelper.priceFormatter.string(from: NSNumber(value: textPrice))
        }
        return nil
    }
    
    var inReview: Bool = false
    
    var isTimeForSales: Bool {
//        if let start = homeData?.salesConfig?.startDate, let end = homeData?.salesConfig?.endDate {
//            return start <= Date() && Date() <= end
//        }
        return false
    }
    
    var idSale: String {
        return  ""//homeData?.salesConfig?.idSale ?? "GenericSales"
    }
    
    static func isShowedSale() -> Bool{
        return UserDefaults.standard.bool(forKey: "isShowedSale_\((AppManager.shared.idSale))")
    }
    
    static func setShowedSale(){
        UserDefaults.standard.set(true, forKey: "isShowedSale_\(AppManager.shared.idSale)")
    }
    
    static func isNotNewApp() -> Bool{
        return UserDefaults.standard.bool(forKey: "isNewInstallation")
    }
    
    static func setIsNewApp(){
        UserDefaults.standard.set(true, forKey: "isNewInstallation")
    }
    
    static var showTutorial: Bool{
        return UserDefaults.standard.bool(forKey: "showTutorial2")
    }
    
    static func setShowTutorial(){
        UserDefaults.standard.set(true, forKey: "showTutorial2")
    }
    
    func saveUserMail() {
        if let sharedDefaults = UserDefaults(suiteName: DeviceManager.group) {
            let token = ""// LoginManager.shared.user?.identificator ?? "null"
            sharedDefaults.set(token, forKey: "userMail")
            sharedDefaults.synchronize()
        }
    }
    
    static var whatNewsVersion : String?{
        set {UserDefaults.standard.set(newValue, forKey: "whatNewsVersion")}
        get{ return UserDefaults.standard.string(forKey: "whatNewsVersion")}
    }
    
    
    static func goSetting(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
}
