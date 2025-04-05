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
    
    class var uid: String?{
        return Auth.auth().currentUser?.uid
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
    class func updateUser(user: UserModel?){
        guard let uid = uid, let user = user else { return}
        getUser().document(uid).setData(user.datafile)
    }
    
    // MARK: USER SERVICES
    class func updatePremiumUsers(user: PremiumUser?){
        guard let uid = uid, let user = user else { return}
        getPremiumUsers().document(uid).setData(user.datafile)
    }
    
    class func getPremiumrData(_ completion: @escaping (PremiumUser?) -> ()){
        guard let uid = uid else {
            completion(nil)
            return
        }
        
        let child = getPremiumUsers().document(uid)
        
        child.getDocument(){ document, error in
            if let child = document?.data(){
                let premium = PremiumUser(value: child)
                LoginManager.shared.user?.premium = premium
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
        
        let child = getUser().document(uid)
        
        child.getDocument(){ document, error in
            if let child = document?.data(){
                let user = UserModel(value: child)
                LoginManager.shared.user = user
                completion(user)
            } else{
                completion(nil)
            }
        }
    }

}
