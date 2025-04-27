//
//  Services.swift
//  Project
//
//  Created by EGONNEDGJ on 20/02/23.
//

import Foundation
import Alamofire

public enum Service: String {
    
    case checkConfig = "configuration/checkconfig"
    case loginWithGoogle = "authentication/googleSignIn"
    case loginWithApple = "authentication/appleSignIn"
    case getTeam = "team/getTeam"
    case getAllTeam = "team/teams"
    case getPilots = "partecipant/getPartecipant"
    case checkName = "checkName" ///not needed
    case createTeam = "Team/addNewTeam"
    case becomesPremium = "account/becomesPremium"
    case cancelPremium = "account/cancelPremium"
    case becamesPremiumGift = "account/becomesPremiumGift"
    case getUser = "account/getUser"
    case getClassification = "classifica/getClassifica"
    case getClassificationForCampaign = "classifica/getClassificaByCampaign"
    case deleteTeam = "team/deleteTeam"
    case registrationToken = "account/registrationToken"
    //events
    case getAllEventsResults = "event/getAllEventsResults"
    
    var url: String{
        var base = EnvHelper.baseUrl
        base.append(self.rawValue)
        return base
    }
    
    var method: HTTPMethod{
        switch self{
        case .checkConfig:
            return .get
        default:
            return .post
        }
        
    }
    
}
