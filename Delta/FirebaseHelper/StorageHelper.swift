//
//  StorageHelper.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import FirebaseStorage
import Kingfisher

class StorageHelper{
    
    class func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    class func getJson(service: String, completion: @escaping (Dictionary<String,Any>?) -> ()) {
           
        let path = "Json/\(service).json"
        let storageRef = Storage.storage().reference(withPath: path)
        storageRef .downloadURL(){ url, error in
            guard let url = url else {
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async { //all changes to UI must be called on main thread
                    if let data = data {
                        completion(data.json)
                        return
                    } else {
                        completion(nil)
                    }
                }
            }.resume()
        }
    }
}
