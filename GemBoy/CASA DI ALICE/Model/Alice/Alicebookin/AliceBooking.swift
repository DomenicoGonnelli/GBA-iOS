//
//  AliceBooking.swift
//  Project
//
//  Created by Domenico Gonnelli on 12/07/25.
//


import Foundation
import FirebaseFirestore

class AliceBookingList : DatabaseModelProtocol{
    
    var booking : [AliceBooking] = []
    
    init(){}
    
    required init(value: [String : Any]) {
        booking = []
        if let values = value["booking"] as? [Dictionary<String,Any>] {
            for value in values{
                booking.append(AliceBooking(value: value))
            }
        }
    }
    
    var datafile: Dictionary<String, Any> {
        var data : [Dictionary<String,Any>] = []
        for element in booking {
            data.append(element.datafile)
        }
        
        let returnData : [String : Any] =
        ["booking" : data ]
        return returnData
    }
}

class AliceBooking : DatabaseModelProtocol{
    
    var day : Date?
    var optionType: AliceOptions = .null
    var range: String?
    
    init(){}
    
    required init(value: [String : Any]) {
        if let value = value["optionType"] as? String {
            optionType = AliceOptions(rawValue: value) ?? .null
        }
        if let value = value["range"] as? String {
            range = value
        }
        
        if let value = value["day"] as? String {
            day = Date(date: value)
        }
    }

    var datafile: Dictionary<String, Any> {
        
        var returnData : [String : Any] = [:]
        returnData["day"] = day?.jsonData()
        returnData["range"] = range ?? ""
        returnData["optionType"] = optionType.rawValue
        return returnData
        
    }
    
   
}
