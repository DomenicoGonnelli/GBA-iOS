//
//  MenuCell.swift
//  Delta
//
//  Created by Domenico Gonnelli on 27/04/25.
//
import UIKit
import Foundation

class MenuCell : UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView?
    @IBOutlet weak var text: UILabel?
    @IBOutlet weak var imageRound: DynamicView?
    
    var item : MenuItem?
    
    func configureCell(item: MenuItem){
        image?.image = item.image
        text?.text = item.text
        self.item = item
    }
    
    func selection(isSelected: Bool){
        
        if isSelected {
            image?.setImageColor(color: .secondaryColor)
            imageRound?.borderColor = .secondaryColor
        } else {
            image?.setImageColor(color: .lightGray)
            imageRound?.borderColor = .lightGray
        }
        
        imageRound?.layoutSubviews()
        
    }
    
    
    
    
}
