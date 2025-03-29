//
//  GradientView.swift
//  Project
//
//  Created by EGONNEDGJ on 04/02/24.
//

import Foundation
import UIKit

class GradientView: UIView{
    
    @IBInspectable var gradientStartColor: UIColor?
    @IBInspectable var gradientEndColor: UIColor?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        grandientBackground(frame: self.frame)
        
    }
    
    func grandientBackground(frame: CGRect){
        if let start = gradientStartColor, let end = gradientEndColor {
            self.backgroundColor = UIColor.getGradientColor(startColor: start, endColor: end, frame: frame)
        }
        
    }
    
    func gradientBackgroundWithDirection(startPoint : CGPoint, endPoint: CGPoint){
        if let start = gradientStartColor, let end = gradientEndColor {
            self.backgroundColor = UIColor.getGradientColor(startColor: start, endColor: end, frame: frame, startPoint:startPoint, endPoint: endPoint  )
        }
    }
    
}
