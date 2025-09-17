//
//  EventModel.swift
//  Project
//
//  Created by EGONNEDGJ on 09/03/23.
//

import Foundation



public class EventModel: DatabaseModelProtocolGet{
    
    var event: EventType?
    var partecipants: [Classification] = []
    var state: EventState?
    var startDate: Date?
    
    var isEnded: Bool{
        return state == .ended
    }
    
    required init(value: [String : Any]) {
        if let ev = value["event"] as? String{
            event = EventType(rawValue: ev)
        }
        
        partecipants = []
        if let values = value["partecipants"] as? [Dictionary<String,Any>] {
            for val in values {
                partecipants.append(Classification(value: val))
            }
        }
        partecipants.sort(by: {$0.position < $1.position})
        
        if let state = value["state"] as? String{
            self.state = EventState(rawValue: state)
        }
        
        if let startDate = value["startDate"] as? String{
            self.startDate = Date(date: startDate)
        }
        
    }
}

public enum EventState: String, CaseIterable{
    case ended = "ENDED"
    case inProgess = "IN_PROGRESS"
    case notStarted = "NOT_STARTED"
}

public enum EventType: String, CaseIterable{
    case firstEvening = "firstEvening"
    case secondEvening = "secondEvening"
    case final = "final"
    
    
    var title: String{
        switch self {
        case .firstEvening:
            return "firstEveningTitle"
        case .secondEvening:
            return "secondEveningTitle"
        case .final:
            return "finalEveningTitle"
        }
    }
    
    var numberOSingers: Int {
        switch self {
        case .firstEvening:
            return 4
        case .secondEvening:
            return 4
        case .final:
            return 1
        }
    }
    
    var message: String {
        switch self {
        case .firstEvening, .secondEvening:
            return String(format: "TeamCreationMessage".localizable, "\(self.numberOSingers)", self.title.localizable)
        case .final:
            return "TeamSelectCapitan"
        }
    }
}
