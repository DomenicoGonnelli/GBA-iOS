//
//  PremiumDataSource.swift
//  Project
//
//  Created by EGONNEDGJ on 13/03/23.
//

import Foundation
import UIKit

public enum PremiumPoints {
    case noAds, moreMoney, liveRaces, changeTeam, leagueCreation
    
    var title: String{
        switch self {
            
        case .noAds:
            return "premiumPageNoAdsTitle"
        case .moreMoney:
            return "premiumPageMoreMoneyTitle"
        case .liveRaces:
            return "premiumPageDirectTitle"
        case .changeTeam:
            return "premiumPageChangeTeamTitle"
        case .leagueCreation:
            return "leagueCreationTitle"
        }
    }

    var message: String{
        switch self {
            
        case .noAds:
            return "premiumPageNoAdsMessage".localizable
        case .moreMoney:
            var add = ""
            if AppManager.shared.homeData?.premiumConfig?.showPremiumBonusExpiration == true,
               let date = AppManager.shared.homeData?.premiumConfig?.expirationDate
            {
                add = String(format: "premiumPageMoreMoneyMessage2".localizable, date.niceLabelAndHours())
            }
            
            return String(format: "premiumPageMoreMoneyMessage".localizable, add)
        case .liveRaces:
            return "premiumPageDirectMessage".localizable
        case .changeTeam:
            
//            if let changeTeamGP = AppManager.shared.homeData?.teamConfig?.changeTeamGP {
//                return String(format: "premiumPageChangeTeamMessageCustom".localizable, "\(changeTeamGP)")
//            }
            
            return  "premiumPageChangeTeamMessage".localizable
        case .leagueCreation:
            return "leagueCreationMessage".localizable
        }
        
    }

    var image: UIImage?{
        var imageName = ""
        switch self {
        case .noAds:
            imageName = "noAdsIcon"
        case .moreMoney:
            imageName = "moreMoneyIcon"
        case .liveRaces:
            imageName = "liveRacesIcon"
        case .changeTeam:
            imageName = "changeTeamIcon"
        case .leagueCreation:
            imageName = "leagueCreation"
        }
        return UIImage(named: imageName)
    }

}
