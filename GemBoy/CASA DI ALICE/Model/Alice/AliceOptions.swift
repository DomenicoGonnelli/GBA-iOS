//
//  AliceOptions.swift
//  Project
//
//  Created by Domenico Gonnelli on 12/07/25.
//

import Foundation
import UIKit


public enum AliceOptions: String, CaseIterable{
    case allDay, halfDay, massages, yoga, null
    
    var name : String {
        switch self {
        case .allDay:
            return "allDayText"
        case .halfDay:
            return "halfDayText"
        case .massages:
            return "messagesText"
        case .yoga:
            return "yogaText"
        case .null:
            return "nullText"
        }
    }
    
    var image : UIImage? {
        switch self {
        case .allDay:
            return UIImage(named: "allday")
        case .halfDay:
            return UIImage(named: "halfday")
        case .massages:
            return UIImage(named: "massage")
        case .yoga:
            return UIImage(named: "yoga")
        case .null:
            return UIImage(named: "flower")
        }
    }
    
    var shortName : String {
        switch self {
        case .allDay:
            return "wellnessShort"
        case .halfDay:
            return "wellnessShort"
        case .massages:
            return "messagesShort"
        case .yoga:
            return "yogaShort"
        case .null:
            return ""
        }
    }
    
    func isAvailable(_ day: Date) -> Bool{
        let dayOfWeek = day.getDayOfWeek()
        return self.dayOfWeek.contains(dayOfWeek)
    }

    var dayOfWeek : [DayOfWeek] {
        switch self {
        case .allDay:
            return [.lunedi, .martedi , .mercoledi, .giovedi, .venerdi]
        case .halfDay:
            return [.lunedi, .martedi , .mercoledi, .giovedi, .venerdi]
        case .massages:
            return [.lunedi, .martedi , .mercoledi, .giovedi, .venerdi]
        case .yoga:
            return [.lunedi, .martedi, .giovedi, .venerdi]
        case .null:
            return []
        }
    }
    
    func hourRange(day: DayOfWeek) -> [String] {
        switch self {
        case .allDay:
            return ["9:00 - 13:00, 15:00 - 21:00"]
        case .halfDay:
            return ["9:00 - 13:00", "15:00 - 21:00"]
        case .massages:
            return ["9:00 - 10:00",
                    "10:00 - 11:00",
                    "11:00 - 12:00",
                    "12:00 - 13:00",
                    "15:00 - 16:00",
                    "16:00 - 17:00",
                    "17:00 - 18:00",
                    "18:00 - 19:00",
                    "19:00 - 20:00",
                    "20:00 - 21:00"]
        case .yoga:
            if day == .lunedi || day == .giovedi {
                return ["8:00 - 9:00"]
            }
            if day == .martedi || day == .venerdi {
                return ["19:00 - 20:00"]
            }
        case .null:
            return []
        }
        return  []
    }

    
}

enum DayOfWeek: String, CaseIterable {
    
    case domenica  = "Domenica",
         lunedi = "Lunedì",
         martedi = "Martedì",
         mercoledi = "Mercoledì",
         giovedi  = "Giovedì",
         venerdi = "Venerdì",
         sabato = "Sabato"
}
