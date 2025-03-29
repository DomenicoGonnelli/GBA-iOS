//
//  OnBoardingButton.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 12/01/23.
//

import Foundation

import Foundation
import  UIKit

protocol OnBoardingGradientDelegate{
    var item : OnBoardingGenericButton? { get set }
}

class OnBoardingButton : UIButton, OnBoardingGradientDelegate{
    var item : OnBoardingGenericButton? {
        didSet{
            if let color = item?.color, let textColor = item?.textColor {
                self.backgroundColor = color
                self.setTitleColor(textColor, for: .normal)
            }
            self.setTitle(item?.text?.localizable, for: .normal)
        }
    }
}

class OnBoardingBorderedButton : RoundedButton, OnBoardingGradientDelegate{
    var item : OnBoardingGenericButton?{
        didSet{
            if let color = item?.color {
                self.borderColor = color
                self.setTitleColor(color, for: .normal)
            }
            self.setTitle(item?.text?.localizable, for: .normal)
            
        }
    }
}
