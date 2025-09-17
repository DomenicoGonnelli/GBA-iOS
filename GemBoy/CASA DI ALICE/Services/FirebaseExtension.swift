//
//  FirebaseExtension.swift
//  GemBoy
//
//  Created by Domenico Gonnelli on 16/09/25.
//

import Foundation
import FirebaseFirestore

extension FirestoreHelper {
    
    class func getBooking() -> CollectionReference{
        return FirestoreHelper.instance.collection("booking")
    }
    
    class func deleteBooking(){
        guard let uid = uid else { return}
        getBooking().document(uid).delete()
    }
    
    class func updateBooking(item: AliceBookingList?){
        guard let uid = uid, let item = item else { return}
        getBooking().document(uid).setData(item.datafile)
    }
    
    class func getBookingData(oneTime: Bool = false, _ completion: @escaping (AliceBookingList?) -> ()){
        guard let uid = uid else {
            completion(AliceBookingList())
            return
        }
        
        let child = getBooking().document(uid)
        if oneTime {
            child.getDocument(){ document, error in
                if let child = document?.data(){
                    let items = AliceBookingList(value: child)
                    LoginManager.shared.booking = items
                    completion(items)
                } else{
                    completion(AliceBookingList())
                }
            }
        } else {
            child.addSnapshotListener{ document, error in
                if let child = document?.data(){
                    let items = AliceBookingList(value: child)
                    LoginManager.shared.booking = items
                    completion(items)
                } else{
                    completion(AliceBookingList())
                }
            }
        }
        
    }
}
