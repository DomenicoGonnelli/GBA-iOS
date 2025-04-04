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
    
    class func saveGame(gameName: String, path: URL, actualDate: Date?, completion: @escaping (Bool) ->()) {

        guard let data = try? Data(contentsOf: path), let uid = FirestoreHelper.uid else {
            completion(false)
            return
        }
        let game_id = path.lastPathComponent
        let path = "\(uid)/Games/\(game_id)"
        print(path)
        let storageRef = Storage.storage().reference(withPath: path)
        // Upload the file to the path "images/rivers.jpg"
        _ = storageRef.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
        
    }
        
        
        
        
    class func getSave(path: URL,completion: @escaping (Data?, String?) -> ()) {
        guard let uid = FirestoreHelper.uid else {
            completion(nil, nil)
            return
        }
        let game_id = path.lastPathComponent
        let path = "\(uid)/Games/\(game_id)"
        let storageRef = Storage.storage().reference(withPath: path)
        
        storageRef.getMetadata(){ metadata, error in
            
            guard let modificationDate = metadata?.updated?.niceLabelAndHours() else {
                completion(nil,nil)
                return
            }
            
            storageRef.downloadURL(){ url, error in
                if let downloadURL = url {
                    URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                        DispatchQueue.main.async {
                            completion(data, modificationDate)
                            return
                        }
                    }.resume()
                } else {
                    completion(nil, nil)
                }
            }
        }
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
