//
//  ClassificationModel.swift
//  Project
//
//  Created by EGONNEDGJ on 09/03/23.
//

import Foundation

public class Classification: DatabaseModelProtocol{
    
    var name: String?
    var song: String?
    private var reward : Int = 0
    var rewardTag : RewardTypology?
    var position: Int = 0
    var id: String = ""
    private var points: Int = 0
    var goOnFinal: Bool = false
    
    var visualName : String?{
        var s = ""
        if let name = name {
            s.append(name)
            s.append(" ")
        }
        
        if let song = song {
            s.append("\n\(song)")
        }
        return s
    }
    
    var classificationName: String{
        var s = ""
        if let name = name {    
            s.append("<m>\(name)</m>")
        }
        
        if let song = song {
            s.append("\n\(song)")
        }
        return s
    }
    
    var fantPoints : Int{
        let bonus = reward != -1 ? reward : 0
        return points + bonus
    }
    
    init(){}
    
    required init(value: [String : Any]) {
        
        if let name = value["name"] as? String{
            self.name = name
        }
        if let id = value["id"] as? String{
            self.id = id
        }
        
        if let name = value["song"] as? String{
            self.song = name
        }
         
        if let tag = value["rewardTag"] as? String{
            self.rewardTag = RewardTypology(rawValue: tag)
        }
        
        reward = value["reward"] as? Int ?? 0
        
        goOnFinal = value["goOnFinal"] as? Bool ?? false
        
        if let position = value["position"] as? Int{
            self.position = position
        }
        if let points = value["points"] as? Int{
            self.points = points
        }
    }
    
    var datafile: Dictionary<String, Any> {
        let returnData : [String : Any] = [:]
        return returnData
    }
}


public enum RewardTypology: String, CaseIterable {
    case doubleWin = "DOUBLE_WIN"
    case exit = "EXIT"
    
    var showIcon: Bool {
        switch self {
        case .doubleWin:
            return true
            
        default:
            return false
        }
    }
}
