//
//  GameDownloadService.swift
//  Project
//
//  Created by EGONNEDGJ on 29/07/25.
//

import Foundation


class GameDownloadService {
    
    
    static func getData(_ completion: @escaping ([EmulatorDownloadModel])->Void){
    
        ServiceHelper.instance.storedJsonService(nameFile: "best_games", request: nil, method: .get){ resp in
            var list : [EmulatorDownloadModel] = []
            if let data = resp?["data"] as? [Dictionary<String,Any>] {
                for item in data {
                    list.append(EmulatorDownloadModel(value: item))
                }
                completion(list)
            } else {
                completion([])
            }
        }
        
    }
}
