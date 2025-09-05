//
//  HomeCell.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 30/12/2020.
//  Copyright © 2020 Domenico Gonnelli. All rights reserved.
//

import Foundation
import UIKit

class HomeCell : UITableViewCell, CellProtocol{
    static var identifier: String = "HomeCell"
    
    @IBOutlet weak var icon : UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var backgroundImage : UIImageView!
    @IBOutlet weak var foregroundColor : UIView!
    
    
    var section : homeSection?{
        didSet{
            icon.image = section?.iconImage
            cellTitle.text = section?.title
            cellTitle.textColor = section?.textColor
            backgroundImage.image = section?.backgorundImage
            foregroundColor.backgroundColor = section?.color.withAlphaComponent(0.7)
        }
    }
    
    var select : Bool = false{ 
        didSet{
            let color : UIColor? = select ? .white : section?.color
            foregroundColor.backgroundColor = color?.withAlphaComponent(0.7)
        }
    }
    
}
