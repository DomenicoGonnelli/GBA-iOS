//
//  UILabel.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import UIKit

protocol XILocalizable {
    var localizedString: String? {get set}
}

@IBDesignable
extension UILabel: XILocalizable{
    
    var attributedString : NSMutableAttributedString{
        
        if let text = attributedText {
            return NSMutableAttributedString(attributedString: text)
        }
        
        if let text = text {
            return NSMutableAttributedString(string: text)
        }
        
        return NSMutableAttributedString(string: "")
    }
    
    
    func updateFont(fontName: String?, size: CGFloat?){
        guard let fontName = fontName, let size = size else { return }
        let font = UIFont(name: fontName , size: size)
        let attributes = self.attributedString
        attributes.addFont(font: font!)
        self.attributedText = attributes

    }
    
    func changeFontFamily(fontName: String?, fontNameBold: String?, size: CGFloat?){
        guard let fontName = fontName,  let fontNameBold = fontNameBold, let size = size else { return }
        let font = UIFont(name: fontName , size: size)
        
        
        let attributes = self.attributedString
        
        let range = NSRange(location: 0, length: attributedString.length)
        
        attributes.enumerateAttribute(.font, in: range) { value, range, pointer in
            guard let currentFont = value as? UIFont else { return }
            
            let isBold = currentFont.fontName.lowercased().contains("bold")
            let replacementFont = UIFont(name: isBold ? fontNameBold : fontName, size: size)
            
            let replacementAttribute = [NSAttributedString.Key.font: replacementFont]
            attributes.addAttributes(replacementAttribute, range: range)
        }
        
        attributes.addLineSpacing(lineSpacing: 6, alignment: .left)
        
        self.attributedText = attributes
    }
    
    
    
    
    
    
    
    @IBInspectable var underline: Bool{
        get {return false}
        set(key){
            if key, let text = self.text {
                let attributeText = NSMutableAttributedString(string: text)
                attributeText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: text.range)
                self.attributedText = attributeText
            }
        }
    }
    
    
    
    @IBInspectable var localizedString: String? {
        get { return nil }
        set(key) {
            if let key = key, let _ = attributedText?.string {
                let attributes = self.attributedString
                attributes.mutableString.setString(key.localizable)
                attributedText = attributes
            } else {
                text = key?.localizable
            }
        }
    }
    
   
    
    func addAttributes(color: UIColor, font: UIFont){
        let attributes = self.attributedString
        attributes.addAlignment(alignment: .center)
        attributes.addColor(color: color)
        attributes.addFont(font: font)
        self.attributedText = attributes
    }
    
    func updateColor(color: UIColor){
        let attributes = self.attributedString
        attributes.addColor(color: color)
        self.attributedText = attributes
    }
    
    
    
    func updateStroke(value: CGFloat?, with color: UIColor?){
        let attributes = self.attributedString
        if let value = value {
            attributes.addBorder(width: -value)
        }
        if let color = color {
            attributes.addBorderColor(color: color)
        }
        self.attributedText = attributes
    }
    
}


extension NSMutableAttributedString{
    
    func addAlignment(alignment: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: self.string.range)
    }

    func addUnderline() {
        self.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: self.string.range)
    }
    
    func addColor(color: UIColor) {
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: self.string.range)
    }
    
    func addBorder(width: CGFloat) {
        self.addAttribute(NSAttributedString.Key.strokeWidth, value: width, range: self.string.range)
    }
    
    func addBorderColor(color: UIColor) {
        self.addAttribute(NSAttributedString.Key.strokeColor, value: color, range: self.string.range)
    }
    
    func addFont(font: UIFont) {
        self.addAttribute(NSAttributedString.Key.font, value: font, range: self.string.range)
    }
    
}
