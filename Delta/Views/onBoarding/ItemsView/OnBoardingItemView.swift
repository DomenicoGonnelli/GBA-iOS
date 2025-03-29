//
//  OnBoardingItemView.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 12/01/23.
//

import Foundation
import UIKit

class OnBoardingItemView : OnBoardingBaseViewController {
    
    static var identifier = "OnBoardingItemView"
    
    static func instance(onBoardingItem: OnBoardingGenericItem) -> OnBoardingItemView{
        let vc = UIStoryboard(name: "OnBoardingPages", bundle: nil).instantiateViewController(withIdentifier: identifier) as! OnBoardingItemView
        vc.onBoardingItem = onBoardingItem
        return vc
    }
    
}
