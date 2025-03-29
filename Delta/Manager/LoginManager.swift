//
//  LoginManager.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import GoogleSignIn
import FirebaseFirestore
import FirebaseAuth

class LoginManager {
    
    static var shared : LoginManager = LoginManager()
    
    func reset(){
        NotificationHelper.unregisterToTopic(topic: .premiumUser)
        LoginManager.shared = LoginManager()
        AppManager.shared.saveUserMail()
    }
    
    public static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    var sentOtp : [String:Int] = [:]
    var user: UserModel?
   
    var isAnonymous: Bool {
        return user == nil || user?.loginMode == .null
    }
    
    public static func tutorialToNotShow(_ isChecked: Bool){
        guard isChecked else {return}
        let preferences = UserDefaults.standard
        let key = "isTutorialShowed"
        preferences.set(true,forKey: key)
        let didSave = preferences.synchronize()
        if didSave {
            print("isTutorialShowed: false")
        }
    }
    
    public static var isTutorialToNotShow : Bool {
        let preferences = UserDefaults.standard
        let key = "isTutorialShowed"
        let tutorial = preferences.bool(forKey: key)
        return tutorial
        
    }
    
    func logout(completion: @escaping ((Bool)->Void)){
        UserDefaults.standard.removeObject(forKey: "userToken")
        completion(true)
        LoginManager.shared.reset()
        try? Auth.auth().signOut()
    }
    
    static var isFaceIDEnabled : Bool{
        set {
            let token = DeviceManager.getUserMail() ?? ""
            UserDefaults.standard.set(newValue, forKey: "isFaceIDEnabled_\(token)")
        }
        get{
            let token = DeviceManager.getUserMail() ?? ""
            return UserDefaults.standard.bool(forKey: "isFaceIDEnabled_\(token)")
        }
    }
    

    
//    func deleteAccount(completion: @escaping ((DeletingErrorEnum)->Void)){
//        
//        UserService.deleteTeam(){ deleted in
//            if deleted || LoginManager.shared.team == nil{
//                if LoginManager.shared.user?.isPremium == true {
//                    UserService.cancelPremium(){ notPremium in
//                        if notPremium  {
//                            completion(.noError)
//                        } else {
//                            completion(.other)
//                        }
//                    }
//                } else {
//                    completion(.noError)
//                }
//            } else {
//                completion(.other)
//            }
//            
//        }
//    }
}
