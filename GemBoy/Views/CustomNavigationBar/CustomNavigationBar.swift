//
//  CustomNavigationBar.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//

import Foundation
import UIKit

@IBDesignable
class CustomNavigationBar : BaseView {
    
    override var nibName: String?{
        return "CustomNavigationBar"
    }
    
    var controller : BaseViewController?
    
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var backImage : UIImageView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var cirleMenu: UIView!
    
    @IBInspectable var titleText: String?{
        didSet {
            title?.localizedString = titleText?.localizable
        }
    }
    
    @IBInspectable var barColor: UIColor = .white
    
    var rightImageButton: UIImage?{
        didSet{
            rightImage.image = rightImageButton
            rightImage.setImageColor(color: barColor)
        }
    }
    
    func setMenu(){
        rightImage.setImageColor(color: .white)
        cirleMenu.isHidden = false
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rightImage.setImageColor(color: barColor)
        backImage.setImageColor(color: barColor)
        title.textColor = barColor
        if !cirleMenu.isHidden {
            rightImage.setImageColor(color: .white)
        }
    }
    
    
    @IBAction func backpressed(_ sender: Any){
        controller?.leftAction()
    }
    
    @IBAction func rightButtonPressed(_ sender: Any){
        controller?.rightAction()
    }
}
