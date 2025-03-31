//
//  StorageLinksModel.swift
//  Project
//
//  Created by EGONNEDGJ on 28/12/23.
//

import Foundation

class StorageLinksModel : DatabaseModelProtocolGet{
    
    var appConfig: String?
    var getRules: String?
    var getEvents: String?
    var getSingers: String?
    var getSingersYoung: String?
    var getRanking: String?
    var getTrashSingers: String?
    var statistics: String?
    var getSongs: String?
    
    init(){}
    
    required init(value: [String : Any]) {
        
        if let val = value["appConfig"] as? String {
            self.appConfig = val
        }
        if let val = value["getSingers"] as? String {
            self.getSingers = val
            
        }
        if let val = value["getSingersYoung"] as? String {
            self.getSingersYoung = val
        }
        if let val = value["getEvents"] as? String {
            self.getEvents = val
        }
        if let val = value["getRules"] as? String {
            self.getRules = val
        }
        if let val = value["getRanking"] as? String {
            self.getRanking = val
        }
        if let val = value["getTrashSingers"] as? String {
            self.getTrashSingers = val
        }
        if let val = value["statistics"] as? String {
            self.statistics = val
        }
        if let val = value["getSongs"] as? String {
            self.getSongs = val
        }
    }

}
