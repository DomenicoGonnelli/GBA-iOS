//
//  SwipableControllerCell.swift
//  Project
//
//  Created by EGONNEDGJ on 16/03/23.
//

import Foundation
import UIKit

class SwipableControllerCell: UICollectionViewCell{
    
    static var identifier = "SwipableControllerCell"
    
    @IBOutlet weak var flag : UILabel!
    @IBOutlet weak var name : UILabel!
    
    
    var isSelectedCampaign: Bool = false{
        didSet {
           contentView.alpha = isSelectedCampaign ? 1 : 0.4
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
