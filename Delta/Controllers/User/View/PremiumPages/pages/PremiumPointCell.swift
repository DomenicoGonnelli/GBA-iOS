//
//  PremiumPointCell.swift
//  Project
//
//  Created by EGONNEDGJ on 16/03/23.
//

import Foundation
import UIKit
import Kingfisher

class PremiumPointCell: UITableViewCell{
    static var identifier = "PremiumPointCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imagePoint: UIImageView!
    
    var premium: PremiumPoints?{
        didSet{
            titleLabel.localizedKey = premium?.title
            messageLabel.setAttributedWithTag(text: premium?.message,mediumSize: 10)
            imagePoint.image = premium?.image
        }
    }
    
    
    var benefit: PremiumBenefitModel?{
        didSet{
            titleLabel.localizedKey = benefit?.title
            messageLabel.setAttributedWithTag(text: benefit?.decription, boldSize: 10)
            
            if let imageUrl = benefit?.image, let url = URL(string: imageUrl) {
                imagePoint.kf.setImage(with: url, completionHandler:  { result in
                    let imageResult = try? result.get().image
                    self.imagePoint.image = imageResult
                })
            }
        }
    }
    
    
    
}
