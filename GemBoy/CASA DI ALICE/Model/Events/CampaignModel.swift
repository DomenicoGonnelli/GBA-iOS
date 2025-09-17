//
//  EveningModel.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 16/01/23.
//

import Foundation
import UIKit

class CampaignModel: SwipableModel, DatabaseModelProtocol{
    
    var eventName: String?
    var eventImageLink: String?
    var events: [EventModel] = []
    var startDate: Date?
    var img: UIImage?
    var eventNameCity : String?
    var id : String?
    var state: CampaingState?
    var rankingAvailable = false
    
    var isEnded: Bool{
        return state == .ended
    }
    
    var titleforRanking: String{
        let city = eventNameCity ?? ""
        return String(format: "PodiumLabelTitle".localizable, city)
    }
    
    override init(){}
    
    required init(value: [String : Any]) {
        events = []
        if let values = value["events"] as? [Dictionary<String,Any>] {
            for val in values{
                events.append(EventModel(value: val))
            }
        }
    
        events.sort(by: {
            if $0.event == .firstEvening && ($1.event == .secondEvening || $1.event == .final){
                return true
            } else if  $0.event == .secondEvening && $1.event == .final {
                return true
            }
            return false
        })
        
        if let state = value["state"] as? String{
            self.state = CampaingState(rawValue: state)
        }
        
        eventImageLink = value["eventImageLink"] as? String
        id = value["id"] as? String
        eventName = value["eventName"] as? String
        eventNameCity = value["eventNameCity"] as? String
        rankingAvailable = value["rankingAvailable"] as? Bool ?? false
        
        if let startDate = value["startDate"] as? String{
            self.startDate = Date(date: startDate)
        }
    }

    var datafile: Dictionary<String, Any> {
        let returnData : [String : Any] = [:]
        return returnData
    }
}

public enum CampaingState: String, CaseIterable{
    case ended = "ENDED"
    case inProgess = "IN_PROGRESS"
    case notStarted = "NOT_STARTED"
}

