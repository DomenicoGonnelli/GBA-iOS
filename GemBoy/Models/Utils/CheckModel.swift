//
//  CheckModel.swift
//  GemBoy
//
//  Created by Domenico Gonnelli on 04/09/25.
//

import Foundation
import FirebaseFirestore
import UIKit

class CheckModel : DatabaseModelProtocol{

    var id: String?
    var loginMode: LoginMode = .null
    var identificator: String? //mail
    var className: String?
    var date: Date?
    var numberLine: String?
    
    init(){}
    
    required init(value: [String : Any]) {
       
    }

    var datafile: Dictionary<String, Any> {
        
        var returnData : [String : Any] = [
            "loginMode" : loginMode.rawValue
        ]
        
        if let identificator = identificator {
            returnData["email"] = identificator
        }
        if let id = id {
            returnData["id"] = id
        }
        
        if let className = className {
            returnData["className"] = className
        }
        if let numberLine = numberLine {
            returnData["numberLine"] = numberLine
        }
        if let date = date {
            returnData["date"] = date.jsonData()
        }
        return returnData
        
    }
}
