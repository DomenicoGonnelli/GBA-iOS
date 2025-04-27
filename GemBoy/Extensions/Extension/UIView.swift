//
//  UIView.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import UIKit

protocol XIBcorner {
    var radius: CGFloat {get set}
}
@IBDesignable
extension UIView: XIBcorner{
    @IBInspectable var radius: CGFloat {
        get{ return self.layer.cornerRadius }
        set(key) {
            self.layer.cornerRadius = key
        }
    }
}

extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
    
    func addShadow(){
        self.dropShadow(color: .black, offSet: CGSize(width: 2, height: 2), radius: 2)
    }
    
    @IBInspectable var shadowColor: UIColor?{
        
        get{
            if let color = layer.shadowColor{
                return UIColor(cgColor: color)
            }
            return nil
        }
        set(key){
            if let key = key {
                self.dropShadow(color: key, opacity: 0.4, offSet: CGSize(width: 0, height: 0), radius: 4)
            }
        }
    }
    
    @IBInspectable var withShadow: Bool{
        get{ return layer.shadowColor != nil}
        set(key){
            if key {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var rotationDegree: CGFloat{
        get{ return transform.d}
        set(key){
            self.transform = CGAffineTransform.identity.rotated(by: key*CGFloat(Double.pi))
        }
    }
    
    
    
    func createImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 1.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    var blur: Bool{
        set(newValue){
            if newValue && !blur  {
                let blurEffect = UIBlurEffect(style: .prominent)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = self.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.alpha = 0.6
                self.addSubview(blurEffectView)
            }
        }
        get{ return self.subviews.contains(where: {$0 is UIVisualEffectView})
            
        }
    }
    
    func blurEffect(){
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        self.addSubview(blurEffectView)
        
    }
    
}


extension UIView {
    func applyCustomIntersectionMask() {
        let rect = self.bounds
        let circleRadius = rect.height / 2
        
        let originalPath = UIBezierPath(roundedRect: rect, cornerRadius: self.layer.cornerRadius)

        let rightCirclePath = UIBezierPath(ovalIn: CGRect(
            x: rect.maxX - rect.height + 4,
            y: rect.midY - circleRadius,
            width: rect.height,
            height: rect.height
        ))
        
        let combinedPath = UIBezierPath()
        combinedPath.append(originalPath)
        combinedPath.append(rightCirclePath)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = combinedPath.cgPath
        maskLayer.fillRule = .evenOdd
        self.layer.mask = maskLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = combinedPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.primaryColorLight.cgColor
        borderLayer.lineWidth = 2
        borderLayer.frame = self.bounds
        
        self.layer.addSublayer(borderLayer)
    }
}
