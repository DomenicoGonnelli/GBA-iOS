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
    case giovani,social, premium, quiz5, quiz20, quiz50, trash, cover, text
    
    
    var title: String{
        
        switch self {
        case .text:
            return "textMedalsTitle".localizable
        case .premium:
            return "premiumMedalsTitle".localizable
        case .quiz5:
            return "quiz5MedalsTitle".localizable
        case .quiz20:
            return "quiz20MedalsTitle".localizable
        case .quiz50:
            return "quiz50MedalsTitle".localizable
        case .trash:
            return "trashMedalsTitle".localizable
        case .cover:
            return "coverMedalsTitle".localizable
        case .giovani:
            return "youngMedalsTitle".localizable
        case .social:
            return "socialMedalsTitle".localizable
        }
        
    }
    
    var desc: String?{
        
        switch self {
        case .text:
            return  String(format: "textMedalsCondition".localizable, self.title)
        case .premium:
            return String(format: "premiumMedalsCondition".localizable, self.title)
        case .quiz5:
            return String(format: "quiz5MedalsCondition".localizable, self.title)
        case .quiz20:
            return String(format: "quiz20MedalsCondition".localizable, self.title)
        case .quiz50:
            return String(format: "quiz50MedalsCondition".localizable, self.title)
        case .trash:
            return String(format: "trashMedalsCondition".localizable, self.title)
        case .cover:
            return String(format: "coverMedalsCondition".localizable, self.title)
        case .giovani:
            return String(format: "youngMedalsCondition".localizable, self.title)
        case .social:
            return String(format: "socialMedalsCondition".localizable, self.title)
        }
        
    }
    
    var isEnabled: Bool{
        
        return .random()
        
    }
    
    var imageName: String{
        
        var img = ""
        switch self {
        case .text:
            img = "medagliaText"
        case .premium:
            img = "premiumMed"
        case .quiz5:
            img = "medagliaQuiz_5"
        case .quiz20:
            img = "medagliaQuiz_20"
        case .quiz50:
            img = "medagliaQuiz_50"
        case .trash:
            img = "medagliaTrash"
        case .cover:
            img = "medagliaCover"
        case .giovani:
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
