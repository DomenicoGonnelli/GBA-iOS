//
//  SharingManager.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 02/02/23.
//

import Foundation
import UIKit

class SharingHelper{
    
    static func avaiableSocials() -> [Social]{
        return [.instagram,.whatsApp, .telegram, .other]
    }
    
    static func share(social: Social, subject : String, text: String, image: UIImage? = nil, vc: BaseViewController? = nil, completion: ((Bool) -> Void)? = nil) {
        guard social.isAvailable else {
            vc?.showAlert(alertTypology: .genericError)
            return
        }
        switch social{
        case .instagram:
            shareOnInstagramStory(image, completion: completion)
        case .other:
            otherSharing(vc: vc, stringToShare: text)
        default:
            openSocialUrl(social: social, subject : subject, text: text)
        }
    }
    
    static func otherSharing(vc: UIViewController?, stringToShare: String){
        guard let vc = vc,let text = stringToShare as NSString? else { return }
       
        let shareViewController: UIActivityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = vc.view
        shareViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        shareViewController.popoverPresentationController?.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
        vc.present(shareViewController, animated: true)
        
    }
    
    private static func openSocialUrl(social: Social, subject : String, text: String){
        guard let url = social.getURL(body: text,subject: subject) else {
            print("Url error or app not installed")
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, completionHandler: .none)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    static func shareOnInstagramStory(_ image: UIImage?, completion: ((Bool) -> Void)? = nil){
        var success = false
        completion?(false)
    }
}

enum Social: String, CaseIterable {
    
    case whatsApp = "SOCIAL_WHATSAPP",
    sms = "SOCIAL_SMS",
    email = "SOCIAL_EMAIL",
    gmail = "SOCIAL_GMAIL",
    telegram = "SOCIAL_TELEGRAM",
    instagram = "SOCIAL_INSTAGRAM",
    other = "SOCIAL_OTHER"
    
    
    func getTitle() -> String{
        return self.rawValue.localizable
    }
    
    func getImage() -> UIImage?{
        return UIImage(named: self.rawValue)
    }
    
    var getPlaceholderUrl : String{
        switch self{
        case .email:
            return "mailto:?body=$BODY&subject=$SUBJECT"
        case .whatsApp:
            return "whatsapp://send?text=$BODY"
        case .sms:
            return "sms:?&body=$BODY"
        case .gmail:
            return "googlegmail://co?body=$BODY&subject=$SUBJECT"
        case .telegram:
            return "tg://msg?text=$BODY"
        case .instagram:
            return "instagram-stories://share?$BODY=$SUBJECT"
        case .other:
            return ""
        }
    }
    
    
    func getURL(body: String,subject:String) -> URL? {
        let bodyText = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let subjectText = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let stringUrl = String(format: self.getPlaceholderUrl, bodyText)
        let repStringUrl = replaceShareContent(text:stringUrl,body:bodyText,subject:subjectText)
        return URL(string: repStringUrl ?? "")
    }
    
    
    func replaceShareContent(text:String,body:String,subject:String)-> String?{
        var newString = text.replacingOccurrences(of: "$BODY", with: body)
        newString = newString.replacingOccurrences(of: "$SUBJECT", with: subject)
        return newString
    }
    
    var isAvailable: Bool{
        
        switch self {
        case.instagram:
            return self.isAppInstalled()
        case .other:
            return true
        default:
           return self.isAppInstalled()
        }
    }
    
    func isAppInstalled() -> Bool {
        
        guard let url = self.getURL(body: "",subject: "") else {
            print("Url error")
            return false
        }
        // check if url can be opened
        let isAppEnabled = UIApplication.shared.canOpenURL(url)
        print("Social \(self) enabled: \(isAppEnabled)")
        return isAppEnabled
    }
    
}
