//
//  FirestoreHelper.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import FirebaseFirestore
import FirebaseAuth
//
class FirestoreHelper{
    
    private static var instance : Firestore{
        get{
            return Firestore.firestore()
        }
    }
    
    private class func getUser() -> CollectionReference{
        return FirestoreHelper.instance.collection("users")
    }
    
    private class func getPremiumUsers() -> CollectionReference{
        return FirestoreHelper.instance.collection("premiumSub")
    }
    
    private class func getStorageLinks() -> CollectionReference{
        return FirestoreHelper.instance.collection("links")
    }
    
    private class func repairCheck() -> CollectionReference{
        return FirestoreHelper.instance.collection("check")
    }
    
    class var uid: String?{
        return Auth.auth().currentUser?.uid
    }
    
    class var user_key: String {
        let uid_current = uid ?? ""
        return "current_user_\(uid_current)"
    }
    class var premium_user_key: String {
        let uid_current = uid ?? ""
        return "current_premium_\(uid_current)"
    }
    
    class func getLinkStorage( _ completion: @escaping (StorageLinksModel?) -> ()){
        
        let child = getStorageLinks().document("configLinks")
        child.getDocument(){ document, error in
            if let child = document?.data(){
                let configLinks = StorageLinksModel(value: child)
                AppManager.shared.links = configLinks
                completion(configLinks)
            } else{
                completion(nil)
            }
        }
    }
    
    // MARK: USER SERVICES
    class func updateRepairCheck(user: CheckModel?){
        guard let uid = uid, let user = user else { return}
        repairCheck().document().setData(user.datafile)
    }
    
    
    // MARK: USER SERVICES
    class func updateUser(user: UserModel?){
        guard let uid = uid, let user = user else { return}
        getUser().document(uid).setData(user.datafile)
        user.saveInJson(key: user_key)
    }
    
    class func deleteUser(){
        guard let uid = uid else { return}
        getUser().document(uid).delete()
    }
    
    // MARK: USER SERVICES
    class func updatePremiumUsers(user: PremiumUser?){
        guard let uid = uid, let user = user else { return}
        getPremiumUsers().document(uid).setData(user.datafile)
        user.datafile.saveInJson(fileName: premium_user_key)
    }
    
    class func deletePremiumUser(){
        guard let uid = uid else { return}
        getPremiumUsers().document(uid).delete()
    }
    
    class func getPremiumrData(_ completion: @escaping (PremiumUser?) -> ()){
        guard let uid = uid else {
            completion(nil)
            return
        }
        
        if let user = Dictionary<String,Any>.readJson(premium_user_key), user.count > 0{
            let premium = PremiumUser(value: user)
            LoginManager.shared.user?.premium = premium
            
            if premium.isActive {
                completion(premium)
                return
            }
        }
        
        let child = getPremiumUsers().document(uid)
        child.getDocument(){ document, error in
            if let child = document?.data(){
                let premium = PremiumUser(value: child)
                LoginManager.shared.user?.premium = premium
                premium.datafile.saveInJson(fileName: premium_user_key)
                completion(premium)
            } else{
                completion(nil)
            }
        }
    }
    
    
    class func getUserData(_ completion: @escaping (UserModel?) -> ()){
        guard let uid = uid else {
            completion(nil)
            return
        }
        
        if let user = Dictionary<String,Any>.readJson(user_key), user.count > 0{
            let user = UserModel(value: user)
            LoginManager.shared.user =  user
            completion(user)
            return
        }
        
        let child = getUser().document(uid)
        
        child.getDocument(){ document, error in
            if let child = document?.data(){
                let user = UserModel(value: child)
                LoginManager.shared.user = user
                user.saveInJson(key: user_key)
                completion(user)
            } else{
                completion(nil)
            }
        }
    }

}
