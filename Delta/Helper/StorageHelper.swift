//
//  StorageHelper.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import UIKit

class StorageHelper{
//    
//    
//    class func addPhoto(_ data : Data? , completion: @escaping (Bool, String?) -> ()) {
//
//        guard let data = data, let uid = LoginManager.shared.user?.identificator else {
//            completion(false, nil)
//            return
//        }
//        let path = "TeamImages/\(uid)/team.jpeg"
//
//        let storageRef = Storage.storage().reference(withPath: path)
//
//        // Upload the file to the path "images/rivers.jpg"
//        let uploadTask = storageRef.putData(data, metadata: nil) { (metadata, error) in
//            guard metadata != nil else {
//                completion(false, nil)
//                return
//            }
//            
//            storageRef.downloadURL(){ (url,error) in
//                guard let downloadURL = url?.absoluteString else {
//                    completion(false, nil)
//                    return
//                }
//                UserService.setUserProfile(url: downloadURL) { upload in
//                    completion(upload, downloadURL)
//                }
//            }
//        }
//    }
//    
//    
//    class func getPhoto(completion: @escaping (UIImage?) -> ()) {
//        if let icon = LoginManager.shared.teamIcon {
//            completion(icon)
//            return
//        }
//        
//        if let img = LoginManager.shared.user?.profilePhotoURL {
//            getDefaulfPhoto(){ img in
//                completion(img)
//            }
//            return
//        }
//        guard let uid = LoginManager.shared.user?.identificator  else {
//            getDefaulfPhoto(){ img in
//                completion(img)
//            }
//            return
//        }
//        let path = "TeamImages/\(uid)/team.jpeg"
//        let storageRef = Storage.storage().reference(withPath: path)
//        storageRef.downloadURL(){ url, error in
//            guard let url = url else {
//                getDefaulfPhoto(){ img in
//                    completion(img)
//                }
//                return
//            }
//            
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                DispatchQueue.main.async { //all changes to UI must be called on main thread
//                    if let data = data {
//                        completion(UIImage(data: data))
//                        return
//                    } else {
//                        getDefaulfPhoto(){ img in
//                            completion(img)
//                        }
//                    }
//                }
//            }.resume()
//        }
//    }
//    
//    class func getDefaulfPhoto(completion: @escaping (UIImage?) -> ()){
//        let defImg = UIImage(named: "genericUser")
//        if let user = LoginManager.shared.user, let url = user.profilePhotoURL{
//            getData(from: url) { data, response, error in
//                guard let data = data, error == nil else {
//                    completion(defImg)
//                    return
//                }
//                completion(UIImage(data: data))
//            }
//        } else {
//            completion(defImg)
//        }
//    }
//    
//    class func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
}
