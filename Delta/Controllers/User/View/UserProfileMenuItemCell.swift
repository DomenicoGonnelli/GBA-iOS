//
//  UserProfileMenuItemCell.swift
//  Project
//
//  Created by Domenico Gonnelli on 23/02/25.
//

import Foundation
import UIKit

class UserProfileMenuItemCell: UITableViewCell {
    
    static var identifier = "UserProfileMenuItemCell"
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemImageBG: UIView!
    @IBOutlet weak var otherImage: UIImageView!
    @IBOutlet weak var arrow: UIImageView!
    
    
    func setData(item: UserProfileMenuItem?){
        itemName.localizedKey = item?.title
        itemImage.image = item?.icon
        itemImageBG.backgroundColor = item?.iconBGColor
        otherImage.image = item?.otherImage
        arrow.isHidden = !(item?.showArrow ?? false)
    }
}
