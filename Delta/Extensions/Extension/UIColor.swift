//
//  UIColor.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import UIKit

extension UIColor {
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        guard let components = self.cgColor.components else { return nil }

        if components.count < 4 {
            return (
                red: components[0],
                green: components[0],
                blue: components[0],
                alpha: components[1]
            )
        }
        return (
            red: components[0],
            green: components[1],
            blue: components[2],
            alpha: components[3]
        )
    }
    
    
    var hexString: String? {
        guard let components = self.colorComponents else { return nil }
        //        if components.alpha != 1 {
        //            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        //        } else {
        return String(format: "%02lX%02lX%02lX", lroundf(Float(components.red) * 255), lroundf(Float(components.green) * 255), lroundf(Float(components.blue) * 255))
        //        }
    }
    
    static var random : UIColor {
        let redValue = CGFloat.random(in: 0...1)
        let greenValue = CGFloat.random(in: 0...1)
        let blueValue = CGFloat.random(in: 0...1)
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        return randomColor
    }
    
    public convenience init(_ hexString: String, alpha: Float = 1.0) {
        var hex = hexString
        
        if hex.hasPrefix("#") {
            let subHex = Substring(hex)
            hex = String(subHex.suffix(from: subHex.index(hex.startIndex, offsetBy: 1)))
        }
        
        if hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil {
            var subHex = Substring(hex)
            if hex.count == 3 {
                let redHex = subHex.prefix(upTo: subHex.index(hex.startIndex, offsetBy: 1))
                let greenHex = String(subHex[subHex.index(hex.startIndex, offsetBy: 1)..<subHex.index(hex.startIndex, offsetBy: 2)])
                let blueHex = subHex.suffix(from: subHex.index(hex.startIndex, offsetBy: 2))
                
                let red =  redHex + redHex
                let green = greenHex + greenHex
                let blue = blueHex + blueHex
                
                hex = red + green + blue
            }
            
            subHex = Substring(hex)
            let redHex = String(subHex.prefix(upTo: subHex.index(hex.startIndex, offsetBy: 2)))
            let greenHex = String(subHex[subHex.index(hex.startIndex, offsetBy: 2)..<subHex.index(hex.startIndex, offsetBy: 4)])
            let blueHex = String(subHex[subHex.index(hex.startIndex, offsetBy: 4)..<subHex.index(hex.startIndex, offsetBy: 6)])
            
            var redInt: CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt: CUnsignedInt = 0
            
            Scanner(string: redHex).scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt32(&greenInt)
            Scanner(string: blueHex).scanHexInt32(&blueInt)
            
            self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
        } else {
            self.init()
        }
    }
    
    static var primaryColor: UIColor{
        return UIColor(named: "primaryColor") ?? UIColor("#333333")
    }
    static var purpleColor: UIColor{
        return UIColor(named: "purple") ?? UIColor("#220000")
    }
    
    static var orangeColor: UIColor{
        return UIColor(named: "orangeColor") ?? .orange
    }
    static var buttonTextColor: UIColor{
        return UIColor(named: "buttonTextColor") ?? .white
    }
    
    static var invertedPrimaryColor: UIColor{
        return UIColor(named: "invertedPrimaryColor") ?? UIColor("#ffffff")
    }
    
    static var primaryColorFix: UIColor{
        return UIColor(named: "primaryColorFix") ?? UIColor("#333333")
    }
    
    static var primaryColorLight: UIColor{
        return UIColor(named: "primaryColorLight") ?? UIColor("#EAEAEA")
    }
    static var secondaryColor: UIColor{
        return UIColor(named: "secondaryColor") ?? UIColor("#BB0402")
    }
    
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        return max(0, min(1, toComponent + value))
    }
    
    private func makeColor(componentDelta: CGFloat) -> UIColor {
            var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Extract r,g,b,a components from the
        // current UIColor
        getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )
        
        // Create a new UIColor modifying each component
        // by componentDelta, making the new UIColor either
        // lighter or darker.
        return UIColor(
            red: add(componentDelta, toComponent: red),
            green: add(componentDelta, toComponent: green),
            blue: add(componentDelta, toComponent: blue),
            alpha: alpha
        )
    }
    
    func lighter(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: componentDelta)
    }
    
    func darker(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: -1*componentDelta)
    }
    
    static func getGradientColor(startColor: UIColor = .red, endColor: UIColor = .systemPink, frame: CGRect, startPoint : CGPoint =  CGPoint(x: 0.0, y: 0.2), endPoint: CGPoint = CGPoint(x: 1.0, y: 0.8)) -> UIColor?{
        let gradientLayer = CALayer.gradientLayer(startColor: startColor, endColor: endColor, frame: frame, startPoint: startPoint, endPoint: endPoint)
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        if let graphicContext = UIGraphicsGetCurrentContext(){
            gradientLayer.render(in: graphicContext)
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return nil}
            UIGraphicsEndImageContext()
            return UIColor(patternImage: image)
        }
        return startColor
    }
    
    static func createColor(_ first: String?,_ second: String?,_ third: String?) -> UIColor {
        
        var redValue = CGFloat.random(in: 0...1)
        var greenValue = CGFloat.random(in: 0...1)
        var blueValue = CGFloat.random(in: 0...1)
        
        if let two = second?.length {
            greenValue = CGFloat(two*13)/CGFloat(255)
        }
        if let one = first?.length {
            blueValue = CGFloat(one*11)/CGFloat(255)
        }
        if let third = third {
            var three = Int(third) ?? third.count * 4
            
            if three < 12 {
                three = three * 17
            } else if three < 33 {
                three = three * 5
            } else if three < 53 {
                three = three * 4
            } else if three < 83 {
                three = three * 3
            }else if three < 95 {
                three = three * 2
            }
            
            redValue = abs(CGFloat(three)/CGFloat(255))
        }
        
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        
        return randomColor
    }
}


extension CALayer {
    
    static func gradientLayer(startColor: UIColor, endColor: UIColor, frame: CGRect, startPoint : CGPoint =  CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5)) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        return gradient
    }
    
}
