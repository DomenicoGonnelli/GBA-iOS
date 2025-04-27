//
//  UILabel+FontSize.swift
//  Delta
//
//  Created by Riley Testut on 12/25/15.
//  Copyright © 2015 Riley Testut. All rights reserved.
//

import UIKit

internal extension UILabel
{
    var currentScaleFactor: CGFloat
    {
        guard let text = self.text else { return 1.0 }
        
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = self.minimumScaleFactor
        
        // Using self.attributedString returns incorrect calculations, so we create our own attributed string
        let attributedString = NSAttributedString(string: text, attributes: [.font: self.font!])
        attributedString.boundingRect(with: self.bounds.size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: context)
        
        let scaleFactor = context.actualScaleFactor
        return scaleFactor
    }
}

@IBDesignable
extension UIButton: XIBLocalizedText{
    @IBInspectable var localizedKey: String?{
        get{ return nil}
        set(key) {
            if let key = key{
                let localizedText = key.localizable
                if(localizedText.contains("<b>") || localizedText.contains("<m>")){
                    let attributedText = NSMutableAttributedString(string: localizedText)
                    if(localizedText.contains("<b>") && localizedText.contains("</b>")){
                        attributedText.setBoldText(size: (titleLabel?.font.pointSize)!, color: nil)
                    }
                    if(localizedText.contains("<m>") && localizedText.contains("</m>")){
                        attributedText.setMediumText(size: (titleLabel?.font.pointSize)!, color: nil)
                    }
                    setAttributedTitle(attributedText, for: .normal)
                } else {
                    setTitle(localizedText, for: .normal)
                }
            }
        }
    }
}
