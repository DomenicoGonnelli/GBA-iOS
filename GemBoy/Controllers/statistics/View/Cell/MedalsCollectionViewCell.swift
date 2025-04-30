//
//  MedalsCollectionViewCell.swift
//  Project
//
//  Created by EGONNEDGJ on 03/01/24.
//

import Foundation
import UIKit

class MedalsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MedalsCollectionViewCell"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    
    func configure(medal: Medals){
        self.image.image = medal.image
        self.title.localizedKey = medal.title
        if medal.isEnabled {
            self.image.removeColor()
        } else {
            self.image.setImageColor(color: .lightGray)
        }
    }
    
    
}

enum Medals: CaseIterable{
    case connect, social, premium, game5, game20, game50, cheat, skin, start
    
    
    var title: String{
        
        switch self {
        case .start:
            return "textMedalsTitle".localizable
        case .premium:
            return "premiumMedalsTitle".localizable
        case .game5:
            return "quiz5MedalsTitle".localizable
        case .game20:
            return "quiz20MedalsTitle".localizable
        case .game50:
            return "quiz50MedalsTitle".localizable
        case .cheat:
            return "trashMedalsTitle".localizable
        case .skin:
            return "coverMedalsTitle".localizable
        case .connect:
            return "youngMedalsTitle".localizable
        case .social:
            return "socialMedalsTitle".localizable
        }
        
    }
    
    var desc: String?{
        
        switch self {
        case .start:
            return  String(format: "textMedalsCondition".localizable, self.title)
        case .premium:
            return String(format: "premiumMedalsCondition".localizable, self.title)
        case .game5:
            return String(format: "quiz5MedalsCondition".localizable, self.title)
        case .game20:
            return String(format: "quiz20MedalsCondition".localizable, self.title)
        case .game50:
            return String(format: "quiz50MedalsCondition".localizable, self.title)
        case .cheat:
            return String(format: "trashMedalsCondition".localizable, self.title)
        case .skin:
            return String(format: "coverMedalsCondition".localizable, self.title)
        case .connect:
            return String(format: "youngMedalsCondition".localizable, self.title)
        case .social:
            return String(format: "socialMedalsCondition".localizable, self.title)
        }
        
    }
    
    var isEnabled: Bool{
        
        switch self {
        case .start:
            return AppManager.isStartedGame
        case .premium:
            return LoginManager.shared.user?.isPremium ?? false
        case .game5:
            return AppManager.shared.totalGames >= 5
        case .game20:
            return AppManager.shared.totalGames >= 15
        case .game50:
            return AppManager.shared.totalGames >= 40
        case .cheat:
            return AppManager.isCheatInserted
        case .skin:
            return AppManager.addedNewSkin
        case .connect:
            return AppManager.connectDevice
        case .social:
            return AppManager.shareWithocial
        }
        
    }
    
    var imageName: String{
        
        var img = ""
        switch self {
        case .start:
            img = "medagliaText"
        case .premium:
            img = "premiumMed"
        case .game5:
            img = "medagliaQuiz_5"
        case .game20:
            img = "medagliaQuiz_20"
        case .game50:
            img = "medagliaQuiz_50"
        case .cheat:
            img = "medagliaTrash"
        case .skin:
            img = "medagliaCover"
        case .connect:
            img = "medagliaGiovani"
        case .social:
            img = "medagliaSocial"
        }
        return img
    }
    
    var image: UIImage?{
        return UIImage(named: imageName)
    }
    
    var alert: AlertModel{
        
        let al = AlertModel()
        al.title = self.title
        al.description = self.desc
        al.imageName = self.imageName
        al.firstButtonTitle = "Ok"
        
        return al
    }
}
