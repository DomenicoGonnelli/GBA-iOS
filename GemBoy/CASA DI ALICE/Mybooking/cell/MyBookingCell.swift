//
//  UserClassificationCell.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 17/01/23.
//

import Foundation
import UIKit

class MyBookingCell: UITableViewCell{
    
    static var identifier = "MyBookingCell"
    
    @IBOutlet weak var option: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var range: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    
    
    func setData(item: AliceBooking){
        option.localizedKey = item.optionType.name
        day.localizedKey = item.day?.toLongLabelDay()
        range.localizedKey = item.range
        img.image = item.optionType.image
        
    }
}
