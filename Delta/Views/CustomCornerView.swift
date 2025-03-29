import UIKit

@IBDesignable
class CustomCornerView: UIView {
    
    @IBInspectable var topLeftRadius: CGFloat = 0 { didSet { updateCorners() } }
    @IBInspectable var topRightRadius: CGFloat = 0 { didSet { updateCorners() } }
    @IBInspectable var bottomLeftRadius: CGFloat = 0 { didSet { updateCorners() } }
    @IBInspectable var bottomRightRadius: CGFloat = 0 { didSet { updateCorners() } }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCorners()
    }
    
    private func updateCorners() {
        let path = UIBezierPath()
        
        let rect = bounds
        let topLeft = CGSize(width: topLeftRadius, height: topLeftRadius)
        let topRight = CGSize(width: topRightRadius, height: topRightRadius)
        let bottomLeft = CGSize(width: bottomLeftRadius, height: bottomLeftRadius)
        let bottomRight = CGSize(width: bottomRightRadius, height: bottomRightRadius)
        
        path.addRoundedRect(in: rect, topLeftRadius: topLeft, topRightRadius: topRight, bottomLeftRadius: bottomLeft, bottomRightRadius: bottomRight)
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIBezierPath {
    func addRoundedRect(in rect: CGRect, topLeftRadius: CGSize, topRightRadius: CGSize, bottomLeftRadius: CGSize, bottomRightRadius: CGSize) {
        
        move(to: CGPoint(x: rect.minX + topLeftRadius.width, y: rect.minY))
        
        addLine(to: CGPoint(x: rect.maxX - topRightRadius.width, y: rect.minY))
        addArc(withCenter: CGPoint(x: rect.maxX - topRightRadius.width, y: rect.minY + topRightRadius.height),
               radius: topRightRadius.width,
               startAngle: CGFloat(-Double.pi / 2),
               endAngle: 0,
               clockwise: true)
        
        addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius.height))
        addArc(withCenter: CGPoint(x: rect.maxX - bottomRightRadius.width, y: rect.maxY - bottomRightRadius.height),
               radius: bottomRightRadius.width,
               startAngle: 0,
               endAngle: CGFloat(Double.pi / 2),
               clockwise: true)
        
        addLine(to: CGPoint(x: rect.minX + bottomLeftRadius.width, y: rect.maxY))
        addArc(withCenter: CGPoint(x: rect.minX + bottomLeftRadius.width, y: rect.maxY - bottomLeftRadius.height),
               radius: bottomLeftRadius.width,
               startAngle: CGFloat(Double.pi / 2),
               endAngle: CGFloat(Double.pi),
               clockwise: true)
        
        addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius.height))
        addArc(withCenter: CGPoint(x: rect.minX + topLeftRadius.width, y: rect.minY + topLeftRadius.height),
               radius: topLeftRadius.width,
               startAngle: CGFloat(Double.pi),
               endAngle: CGFloat(-Double.pi / 2),
               clockwise: true)
        
        close()
    }
}
