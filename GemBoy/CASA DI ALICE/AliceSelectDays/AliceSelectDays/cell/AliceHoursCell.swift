//
//  GranPrixCell.swift
//  Project
//
//  Created by EGONNEDGJ on 21/02/23.
//

import Foundation

import Foundation
import UIKit

class AliceHoursCell: UITableViewCell{
    
    static var identifier = "AliceHoursCell"
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
 
    
    func setData(isMine: Bool, isAvailable: Bool){
        if isMine {
            containerView.backgroundColor = .secondaryColor
        } else if isAvailable {
            containerView.backgroundColor = .systemGreen
        } else {
            containerView.backgroundColor = .systemRed
        }
    }
    
    func setTitle(text: String){
        positionLabel.text = text
    }
}
