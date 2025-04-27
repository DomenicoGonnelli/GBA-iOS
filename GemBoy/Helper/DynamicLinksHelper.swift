
import Foundation
//import FirebaseDynamicLinks

class DynamicLinksHelper{
    
    static let keyLink : String = "link"
    
    static func isDynamicLink(url: URL) -> Bool{
        return url.absoluteString.starts(with: baseDl)
    }
    
    static func getTypeFromLink(url: URL) -> DynamicLinksType?{
        let lastPath = url.lastPathComponent
        let link = DynamicLinksType(rawValue: lastPath)
        return link
    }
    
    static func createShortLink(from link: String, completion : @escaping (URL)->Void){
        
        guard let link = URL(string: link) else { return }
        let dynamicLinksDomainURIPrefix = baseDl
//        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
//        linkBuilder?.shorten(){ url, warning, error in
//            guard let url = url else { return }
//            completion(url)
//            print("The short URL is: \(url)")
//        }
        completion(link)
        
    }
    
    
    
    static var baseDl : String{
        return "https://fonefantasy.page.link"
    }
    
    static func handleDeepLink(shortUrl: URL, aspectedDL: DynamicLinksType? = nil){
        var complete = shortUrl.absoluteString
        var completeURL =  shortUrl
        
        if complete.contains("?link=") {
            complete = complete.replacingOccurrences(of: "\(baseDl)/?link=", with: "")
            completeURL = URL(string: complete) ?? shortUrl
        }
        let dynamicLinksType = getTypeFromLink(url: completeURL) ?? .null
        
        let dlToTheck = aspectedDL ?? dynamicLinksType
                
        if dlToTheck == dynamicLinksType {
            print("Founded DL: \(dynamicLinksType.rawValue)")
            let code = complete.components(separatedBy: dynamicLinksType.rawValue)
            DynamicLinksHelper.shared.linkInfo = code.last
            DynamicLinksHelper.shared.dynamicLink = dynamicLinksType
            NotificationManager.shared.notificationHandler?()
        }
    }
    
    static let shared = DynamicLinksHelper()
    var dynamicLink: DynamicLinksType = .null
    var linkInfo: String?
    
    static var storedLink: String?{
        return UserDefaults.standard.string(forKey: "storedDL")
    }
    
    static func setStoredLink(link: String){
        UserDefaults.standard.set(link, forKey: "storedDL")
    }
    
    static func decode(from code: String, occorences: Int) -> String?{
        
        var newCode = code
        if code.contains("?code=") {
            newCode = newCode.replacingOccurrences(of: "?code=", with: "")
        }
        newCode = newCode.replacingOccurrences(of: "?code%3D", with: "")
        if newCode.count >= occorences {
            let returnCode = String(newCode.prefix(occorences))
            print("fonded code \(returnCode)")
            return returnCode
        }
        return newCode
       
    }
    
    
}

public enum DynamicLinksType: String{
    case discoverClassification, leaguesAccess, driverInvitation, null
    
    static func isDynamicLink(_ string: String) -> Bool{
        return string.contains("discoverClassification") || string.contains("leaguesAccess") || string.contains("driverInvitation")
    }
    
    
    
    func getDynamicLink(code: String?, completion : @escaping (String)->Void){
        if let text = code {
            let base = "\(DynamicLinksHelper.baseDl)/?link=\(DynamicLinksHelper.baseDl)/\(self.rawValue)?code=\(text)&apn=com.aloiadavide.fonefantasy&isi=1671742077&ibi=com.Domenico.Gonnelli.fonefantasy"
            DynamicLinksHelper.createShortLink(from: base){ value in
                completion(value.absoluteString)
            }
        } else {
            completion("\(DynamicLinksHelper.baseDl)/\(self.rawValue)")
        }
    }
}
