//
//  Enumerators.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 30/12/2020.
//  Copyright © 2020 Domenico Gonnelli. All rights reserved.
//

import Foundation
import UIKit

public enum homeSection : CaseIterable {
    case roulette, question, puzzle, list, other
    
    var title : String{
        switch self {
        case .roulette:
            return "rouletteTitle".localizable
        case .puzzle:
            return "puzzleTitle".localizable
        case .question:
            return "questionTitle".localizable
        case .list:
            return "listTitle".localizable
        case .other:
            return "other_Title".localizable
        }
    }
    
    var color : UIColor {
        switch self {
        case .roulette:
            return UIColor("#0C9D18")
        case .puzzle:
            return UIColor("#00E1FF")
        case .question:
            return UIColor("#FFCB00")
        case .list:
            return UIColor("#FF8383")
        case .other:
            return .white
        }
    }
    
    var textColor : UIColor {
        switch self {
        case .roulette:
            return UIColor.white
        case .puzzle, .other:
            return UIColor.purple
        case .question:
            return UIColor.black
        case .list:
            return UIColor("#000649")
        }
    }
    
    var backgorundImage: UIImage?{
        switch self {
        case .roulette:
            return UIImage(named: "ruotaBG")
        case .puzzle:
            return UIImage(named: "puzzleBG")
        case .question:
            return UIImage(named: "questionBG")
        case .list:
            return UIImage(named: "listBG")
        case .other:
            return UIImage(named: "puzzleBG")
        }
    }
    
    var iconImage: UIImage?{
        switch self {
        case .roulette:
            return UIImage(named: "RuotaIcon")
        case .puzzle:
            return UIImage(named: "puzzleIcon")
        case .question:
            return UIImage(named: "questionIcon")
        case .list:
            return UIImage(named: "listIcon")
        case .other:
            return UIImage(named: "lock")
        }
    }
}

