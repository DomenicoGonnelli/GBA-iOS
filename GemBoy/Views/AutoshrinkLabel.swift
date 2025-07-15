//
//  AutoshrinkLabel.swift
//  GemBoy
//
//  Created by Domenico Gonnelli on 06/07/25.
//

//
//  AutoshrinkLabel.swift
//  Project
//
//  Created by EGONNEDGJ on 29/03/23.
//

import Foundation
import UIKit

class AutoshrinkLabel: UILabel{
    
    var isManualAutoshrink : Bool = false
    
    var scaleFactor : CGFloat{
        let inset = self.intrinsicContentSize.height
        let real = self.frame.height
        return real/inset
    }
    
    var addingValueToFont : CGFloat = 0
    var retryToAutoshrink = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setAutoshrink()
    }
    
    func setAutoshrink(){
        let scale = scaleFactor
        guard isManualAutoshrink, scale < 1, retryToAutoshrink < 5 else {return}
        
        self.attributedString.enumerateAttributes(in: NSRange(location: 0, length: attributedString.length), options: []){ attr, range,_ in
            
            if let font = attr[.font] as? UIFont{
                let size = font.pointSize + addingValueToFont
                let newFont = font.withSize(size * scale)
                let attribute = self.attributedString
                attribute.addAttribute(.font, value: newFont, range: range)
                self.attributedText = attribute
            }
        }
        retryToAutoshrink += 1
    }
}
