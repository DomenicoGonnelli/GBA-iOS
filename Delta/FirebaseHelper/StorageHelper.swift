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
        
        if LoginManager.shared.user?.isPremium == true {
            guard let data = try? Data(contentsOf: path), let uid = FirestoreHelper.uid else {
                completion(false)
                return
            }
            let game_id = path.lastPathComponent
            let path = "\(uid)/Games/\(game_id)"
            
            let storageRef = Storage.storage().reference(withPath: path)
            // Upload the file to the path "images/rivers.jpg"
            _ = storageRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            }
            
        } else {
            completion(false)
        }
    }
    
    class func deleteAllGames(completion: @escaping (Bool) ->()) {

        guard let uid = FirestoreHelper.uid else {
            completion(true)
            return
        }
        let path = "\(uid)/Games"
        
        deletePath(at: path) { error in
            completion(error == nil)
        }
        
    }
    
    class func deletePath(at path: String, completion: @escaping (Error?) -> Void) {
        let storageRef = Storage.storage().reference(withPath: path)

        storageRef.listAll { (result, error) in
            if let error = error {
                completion(error)
                return
            }

            let dispatchGroup = DispatchGroup()
            var deletionError: Error?
            
            guard let result = result else {
                completion(deletionError)
                return
            }

            for item in result.items {
                dispatchGroup.enter()
                item.delete { error in
                    if let error = error {
                        deletionError = error
                    } else {
                        print("File eliminato: \(item.fullPath)")
                    }
                    dispatchGroup.leave()
                }
            }

            for prefix in result.prefixes {
                dispatchGroup.enter()
                deletePath(at: prefix.fullPath) { error in
                    if let error = error {
                        deletionError = error
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(deletionError)
            }
        }
    }

        
        
        
        
    class func getSave(path: URL,completion: @escaping (Data?, String?) -> ()) {
        if LoginManager.shared.user?.isPremium == true{
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
        } else {
            completion(nil, nil)
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
