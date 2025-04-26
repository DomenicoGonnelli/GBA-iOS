//
//  ChartModel.swift
//  Project
//
//  Created by EGONNEDGJ on 20/01/24.
//

import Foundation
import UIKit

class ChartModel: DatabaseModelProtocol {
    
    var title : String?
    var section : String?
    var data : [SelectedYoungerModel] = []
    
    
    required init(value: [String : Any]) {
        title = value["title"] as? String
        section = value["section"] as? String
        if let items = value["data"] as? [Dictionary<String,Any>] {
            data = []
            for item in items {
                data.append(SelectedYoungerModel(value: item))
            }
        }
    }
    
    var datafile: Dictionary<String, Any>{
        return [:]
    }
    
}


class SelectedYoungerModel: DatabaseModelProtocol, Equatable {
    
    static func == (lhs: SelectedYoungerModel, rhs: SelectedYoungerModel) -> Bool {
        return lhs.singerID == rhs.singerID
    }
    
    var singerID : String?
    var percent : Int?
    
 
    required init(value: [String : Any]) {
        singerID = value["singerID"] as? String
        percent = value["percent"] as? Int
    }
    
    var datafile: Dictionary<String, Any>{
        return [
            "singerID" : singerID ?? "",
            "percent" : percent ?? 0
        ]
    }
}
