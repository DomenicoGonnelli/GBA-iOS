//
//  DynamicView.swift
//  Project
//
//  Created by Domenico Gonnelli on 17/01/25.
//

import Foundation
import UIKit

class DynamicView: UIView{
    
    @IBInspectable var borderWidth : CGFloat = 0
    @IBInspectable var borderColor : UIColor = .clear
    
    override func layoutSubviews(){
        
        super.layoutSubviews()
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = radius
    }
    
    override func draw(_ rect: CGRect){
        super.draw(rect)
        
        
        
    }
    
    
    
}
