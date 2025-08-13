//
//  EmulatorDownloadModel.swift
//  Project
//
//  Created by EGONNEDGJ on 29/07/25.
//

import Foundation
import UIKit

class EmulatorDownloadModel: DatabaseModelProtocolGet {
    
   
    var emulator : System?
    var games : [GameDownloadModel] = []
    
    required init(value: [String : Any]) {
        
        if let system = value.keys.first {
            emulator = System(rawValue: system.lowercased())
        }
        
        games = []
        if let values = value.values.first as? [Dictionary<String,Any>] {
            for item in values {
                let game = GameDownloadModel(value: item)
                games.append(game)
            }
        }
    }
    
}



class GameDownloadModel: DatabaseModelProtocolGet {
    
    var title : String?
    var downloadLink : String?
    var imageLink: String?
    var imageName: String?
    var id: Int?
    
    required init(value: [String : Any]) {
        
        if let val = value["id"] as? Int {
            id = val
        }
        
        if let val = value["imgLink"] as? String {
            imageLink = val
        }
        if let val = value["imgName"] as? String {
            imageName = val
        }
        
        if let data = value["data"] as? [String:Any] {
            let lang = DeviceManager.getLang().rawValue
            if let spec = data[lang] as? [String:Any] {
                self.title = spec["name"] as? String
                self.downloadLink = spec["link"] as? String
            } else if let spec = data["en"] as? [String:Any] {
                self.title = spec["name"] as? String
                self.downloadLink = spec["link"] as? String
            }
        }
    }
    
}



