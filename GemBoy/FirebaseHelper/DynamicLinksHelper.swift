
import Foundation
//import FirebaseDynamicLinks

class DynamicLinksHelper{
    
    static let keyLink : String = "key"
    
    static func isDynamicLink(url: URL) -> Bool{
        return url.absoluteString.starts(with: baseDl)
    }
    
    static func getTypeFromLink(url: URL) -> DynamicLinksType{
        return DynamicLinksType.getDynamicLink(url.absoluteString)
    }
        
    //gemboy://premiumSubscription?key=jfr
    static var baseDl : String{
        return "gemboy://"
    }
    
    static func handleDeepLink(shortUrl: URL, aspectedDL: DynamicLinksType? = nil){
        let dynamicLinksType = getTypeFromLink(url: shortUrl)
        let dlToTheck = aspectedDL ?? dynamicLinksType
                
        if dlToTheck == dynamicLinksType {
            print("Founded DL: \(dynamicLinksType.rawValue)")
            let code = shortUrl.absoluteString.components(separatedBy: dynamicLinksType.rawValue)
            DynamicLinksHelper.shared.linkInfo = code.last
            DynamicLinksHelper.shared.dynamicLink = dynamicLinksType
            NotificationManager.shared.notificationHandler?()
        }
    }
    
    static let shared = DynamicLinksHelper()
    var dynamicLink: DynamicLinksType = .null
    var linkInfo: String?
    
    static var storedLink: String?{
        set{
            UserDefaults.standard.set(newValue, forKey: "storedDL")
        }
        get {
            return UserDefaults.standard.string(forKey: "storedDL")
        }
    }

}

public enum DynamicLinksType: String, CaseIterable{
    case premiumSubscription, null
    
    static func getDynamicLink(_ string: String) -> DynamicLinksType{
        var link : DynamicLinksType = .null
        DynamicLinksType.allCases.forEach({
            if string.contains($0.rawValue) {
                link = $0
            }
        })
        return link
    }
    
}
