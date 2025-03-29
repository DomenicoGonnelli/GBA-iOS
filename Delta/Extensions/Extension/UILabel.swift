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


//
//  UILabel.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//

import Foundation
import UIKit

extension UILabel {
    
    /**
     Increase space between lines of the lebel's text.
     - parameter lineSpacing: new value of line spacing.
     - parameter alignment: text alignment type
     */
    func setLineSpacing(lineSpacing: CGFloat, alignment: NSTextAlignment? = nil) {
        
        guard text != nil else {
            return
        }

        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        //Set LineSpacing property in points ***
        paragraphStyle.lineSpacing = lineSpacing // Whatever line spacing you want in points
        
        // If defined, set text alignment
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        self.attributedText = attributedString

    }
    
    class func fontSizeForMainScreen(factor: CGFloat, max: CGFloat) -> CGFloat{
        return min(factor * UIScreen.main.bounds.height, max)
    }
    
    func addLinkWithAction(linkKey: String?, fontSize: CGFloat = 14, target: Any?, action: Selector?){
        guard let linkKey = linkKey  else {return}
        let principalContent = self.attributedString
        let linkContent = linkKey.localizable.attributedString(fontStyle: .medium, size: fontSize)
        linkContent.addUnderline()
        principalContent.append(linkContent)
        principalContent.addLineSpacing(lineSpacing: 6, alignment: textAlignment)
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        self.attributedText = principalContent
    }
    
    
    func addLinkWithAction(principalTextKey: String, linkKey: String,fontSize: CGFloat = 14, target: Any?, action: Selector? ){
        self.localizedKey = principalTextKey
        addLinkWithAction(linkKey: linkKey, fontSize: fontSize,target: target, action: action)
    }
}


protocol XIBInterline {
    var interlineSpace: CGFloat {get set}
}
@IBDesignable
extension UILabel: XIBInterline{
    @IBInspectable var interlineSpace: CGFloat {
        get{ return self.interlineSpace}
        set(key) {
            self.setLineSpacing(lineSpacing: key, alignment: textAlignment)
        }
    }
}

protocol XIBUnderline {
    var singleUnderline: Bool {set get}
}

@IBDesignable
extension UILabel: XIBUnderline{
    @IBInspectable var singleUnderline: Bool{
        get{
            return false
        }
        set(key) {
            let underlinedText = attributedString
            if key {
                underlinedText.addUnderline()
            } else {
                underlinedText.removeUnderline()
            }
            self.attributedText = underlinedText
        }
    }
}

protocol XIBLocalizedText {
    var localizedKey: String? {set get}
}

@IBDesignable
extension UILabel: XIBLocalizedText{
    @IBInspectable var localizedKey: String?{
        get{ return nil}
        set(key) {
            if let key = key{
                var localizedText = key.localizable
                if localizedText.contains("<AppName/>") {
                    let name = AppManager.shared.homeData?.iosConfig?.appName ?? "F1 Fantasy"
                    localizedText = localizedText.replacingOccurrences(of: "<AppName/>", with: name)
                }
                self.setAttributedWithTag(text: localizedText)
            }
        }
    }
    
    func setAttributedWithTag(text: String?, boldColor: UIColor? = nil, boldSize: CGFloat? = nil, mediumColor: UIColor? = nil, mediumSize: CGFloat? = nil, withLineSpace: Bool = true, lineSpace: CGFloat = 6){
        let attrText = self.attributedString
        guard let text = text else {
            self.text = nil
            return
        }
        attrText.mutableString.setString(text)
        if let font = self.font {
            attrText.addAttribute( .font, value: font, range: text.range)
        }
        
        if(text.contains("<b>") && text.contains("</b>")){
            let points = boldSize ?? font.pointSize
            attrText.setBoldText(size: points, color: boldColor)
        }
        if(text.contains("<m>") && text.contains("</m>")){
            let points = mediumSize ?? font.pointSize
            attrText.setMediumText(size: points, color: mediumColor)
        }
        
        if(text.contains("<u>") && text.contains("</u>")){
            let points = mediumSize ?? font.pointSize
            attrText.setUnderlinedText(size: points, color: mediumColor)
        }
        
        if withLineSpace {
            attrText.addLineSpacing(lineSpacing: lineSpace, alignment: textAlignment)
        }
        self.attributedText = attrText
    }
    
    func appendAttributedWithTag(text: String?, boldColor: UIColor? = nil, mediumColor: UIColor? = nil){
       
        guard let text = text else {
            self.text = nil
            return
        }
        
        let newAttr = NSMutableAttributedString(attributedString: self.attributedString)
        newAttr.mutableString.setString(text)
        if(text.contains("<b>") && text.contains("</b>")){
            newAttr.setBoldText(size: font.pointSize, color: boldColor)
        }
        if(text.contains("<m>") && text.contains("</m>")){
            newAttr.setMediumText(size: font.pointSize, color: mediumColor)
        }
        
        let newText = self.attributedString
        newText.append(newAttr)
        self.attributedText = newText
    }
    
    func localizedKeyWithArguments(key: String?, arguments: CVarArg, boldColor: UIColor? = nil, boldSize: CGFloat? = nil, mediumColor: UIColor? = nil, mediumSize: CGFloat? = nil, withLineSpace: Bool = true, lineSpace: CGFloat = 6){
        guard let key = key else { return }
        let text = String(format: key.localizable, arguments)
        setAttributedWithTag(text: text, boldColor: boldColor, boldSize: boldSize, mediumColor: mediumColor, mediumSize: mediumSize, withLineSpace: withLineSpace, lineSpace: lineSpace)
    }
}
