//
//  DashedView.swift
//  Project
//
//  Created by Domenico Gonnelli on 06/02/25.
//

import Foundation
import UIKit

@IBDesignable
class DashedView: UIView {
    
    // Proprietà per personalizzare gli angoli arrotondati
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet { updateView() }
    }
    
    // Proprietà per personalizzare il bordo tratteggiato
    @IBInspectable var dashColor: UIColor = UIColor.black {
        didSet { updateView() }
    }
    
    @IBInspectable var dashWidth: CGFloat = 2 {
        didSet { updateView() }
    }
    
    @IBInspectable var dashLength: CGFloat = 5 {
        didSet { updateView() }
    }
    
    @IBInspectable var dashSpacing: CGFloat = 3 {
        didSet { updateView() }
    }
    
    private let borderLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
    
    private func updateView() {
        // Rimuove eventuali bordi precedenti
        borderLayer.removeFromSuperlayer()
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = dashColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = dashWidth
        borderLayer.lineDashPattern = [dashLength, dashSpacing] as [NSNumber]
        borderLayer.frame = bounds
        
        layer.addSublayer(borderLayer)
    }
}
