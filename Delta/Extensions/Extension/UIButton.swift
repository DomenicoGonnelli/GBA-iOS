//
//  UIButton.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import UIKit

extension UIButton : XILocalizable{
    
    @IBInspectable var localizedString: String? {
        get { return nil }
        set(key) {
            guard let text = key?.localizable else {return}
            
            if let title = self.attributedTitle(for: .normal) {
                let attr = NSMutableAttributedString(attributedString: title)
                attr.mutableString.setString(text)
                setAttributedTitle(attr, for: .normal)
            } else {
                setTitle(key?.localizable, for: .normal)
            }
        }
    }
    
    @IBInspectable var underline: Bool{
        get {return false}
        set(key){
            if key {
                let text = self.title(for: .normal) ?? ""
                let attributeText = NSMutableAttributedString(string: text)
                attributeText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: text.range)
                attributeText.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal) as Any, range: text.range)
                self.setAttributedTitle(attributeText, for: .normal)
            }
        }
    }
    
    func enable(_ value: Bool){
        if value {
            self.isUserInteractionEnabled = true
            self.alpha = 1
        } else {
            self.isUserInteractionEnabled = false
            self.alpha = 0.5
        }
    }
}
