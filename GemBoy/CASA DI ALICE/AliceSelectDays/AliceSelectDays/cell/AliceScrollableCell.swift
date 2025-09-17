//
//  GrapPrixScrollableCell.swift
//  Project
//
//  Created by EGONNEDGJ on 28/02/23.
//

import Foundation
import UIKit

class AliceScrollableCell: UICollectionViewCell {
    
    static var identifier = "AliceScrollableCell"
    
    @IBOutlet weak var gPName: UILabel!
    @IBOutlet weak var aliceAddOn: UILabel!
    @IBOutlet weak var gPDate: UILabel!
    @IBOutlet weak var gPImage: UIImageView!
    
    
    func setData(event: AliceOptions, addon: AliceOptions, day: Date){
        
        gPName.localizedKey = event.name
        aliceAddOn.isHidden = true
        if addon != .null {
            aliceAddOn.isHidden = !addon.isAvailable(day)
            aliceAddOn.localizedKey = "+ \(addon.name.localizable)"
        }
        print(day)
        gPDate.text = day.toLongLabelDay()
        
    }
}
