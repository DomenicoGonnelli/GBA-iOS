//
//  UIImageView.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation

import UIKit

extension UIImageView {
    
    func setImageColor(color: UIColor?) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    
}


protocol XIColorable {
    var setTintColor: UIColor? {get set}
}

@IBDesignable
extension UIImageView: XIColorable{
    
    @IBInspectable var setTintColor : UIColor?{
        get{return self.tintColor}
        set(key){
            self.setImageColor(color: key)
        }
    }
    
    @IBInspectable var horizontalFlip: Bool{
        get{ return true}
        set(key){
            self.image = self.image?.withHorizontallyFlippedOrientation()
        }
    }
    
    
}
