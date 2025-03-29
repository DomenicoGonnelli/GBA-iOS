//
//  FirestoreHelper.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import FirebaseFirestore
//import FirebaseAuth
//
class FirestoreHelper{
    
    private static var instance : Firestore{
        get{
            return Firestore.firestore()
        }
    }
    
    private class func getHelp() -> CollectionReference{
        return FirestoreHelper.instance.collection("helper_2025")
    }
    
    //
    //    private class func getTeams() -> CollectionReference{
    //        return FirestoreHelper.instance.collection("team")
    //    }
    //    
    //    private class func getWallet() -> CollectionReference{
    //        return FirestoreHelper.instance.collection("wallet")
    //    }
    
    //    class var uid: String?{
    //        return Auth.auth().currentUser?.uid
    //    }
    
    // MARK: WALLET SERVICES
    class func updateWallet(data: [String:Any]){
        getHelp().document(Date().toLongLabel()).setData(data)
    }
    
//}
//
//    class func getWalletData(oneTime: Bool = true,_ completion: @escaping (WalletModel?) -> ()){
//        guard let uid = uid else {
//            completion(nil)
//            return
//        }
//        
//        let child = getWallet().document(uid)
//        if oneTime {
//            child.getDocument(){ document, error in
//                if let child = document?.data(){
//                    let wallet = WalletModel(value: child)
//                    completion(wallet)
//                } else{
//                    completion(nil)
//                }
//            }
//        } else {
//            child.addSnapshotListener{ document, error in
//                if let child = document?.data(){
//                    let wallet = WalletModel(value: child)
//                    completion(wallet)
//                } else{
//                    completion(nil)
//                }
//            }
//        }
//    }
//    
//    // MARK: USER SERVICES
//    class func updateUser(user: UserModel?){
//        guard let uid = uid, let user = user else { return}
//        getUser().document(uid).setData(user.datafile)
//    }
//    
//    class func getUserData(oneTime: Bool = true,_ completion: @escaping (UserModel?) -> ()){
//        guard let uid = uid else {
//            completion(nil)
//            return
//        }
//        
//        let child = getUser().document(uid)
//        if oneTime {
//            child.getDocument(){ document, error in
//                if let child = document?.data(){
//                    let user = UserModel(value: child)
//                    LoginManager.shared.user = user
//                    completion(user)
//                } else{
//                    completion(nil)
//                }
//            }
//        } else {
//            child.addSnapshotListener{ document, error in
//                if let child = document?.data(){
//                    let user = UserModel(value: child)
//                    LoginManager.shared.user = user
//                    getTeamForUser(){ team in
//                        LoginManager.shared.team = team
//                        completion(user)
//                    }
//                } else{
//                    completion(nil)
//                }
//            }
//        }
//    }
//    
//    // MARK: USER SERVICES
//    class func updateTeam(team: TeamModel?){
//        guard let uid = uid, let team = team else { return }
//        getTeams().document(uid).setData(team.datafile)
//    }
//    
//    class func deleteTeam(completion: @escaping (Bool)->Void){
//        guard let uid = uid else { return }
//        getTeams().document(uid).delete{ error in
//            print(error == nil)
//        }
//    }
//    
//    class func getTeamForUser(oneTime: Bool = true,_ completion: @escaping (TeamModel?) -> ()){
//        guard let uid = uid else {
//            completion(nil)
//            return
//        }
//        let child = getTeams().document(uid)
//        if oneTime {
//            child.getDocument(){ document, error in
//                if let child = document?.data(){
//                    let team = TeamModel(value: child)
//                    LoginManager.shared.team = team
//                    completion(team)
//                } else{
//                    completion(nil)
//                }
//            }
//        } else {
//            child.addSnapshotListener{ document, error in
//                if let child = document?.data(){
//                    let team = TeamModel(value: child)
//                    LoginManager.shared.team = team
//                    completion(team)
//                } else{
//                    completion(nil)
//                }
//            }
//        }
//    }
}
