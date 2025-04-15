//
//  OnBoardingDataSource.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 12/01/23.
//

import Foundation
import UIKit
import SwiftUI

class OnBoardingDataSource{
    static var controllers : [OnBoardingBaseViewController] {
        //Set First View
    
        let firstItem = OnBoardingGenericItem()
        firstItem.title = String(format: "Tutorial_1_title".localizable)
        firstItem.body = "Tutorial_1_message".localizable
        firstItem.texColor = .white
        firstItem.imageName = "1tutorial"
        firstItem.backgroundName = "1tutorial_bg"
        firstItem.color = UIColor("B1A59A")
        let button = OnBoardingGenericButton()
        button.text = "Tutorial_1_button1".localizable
        button.action = .next
        let button2 = OnBoardingGenericButton()
        button2.text = "Tutorial_1_button2".localizable
        button2.action = .goToSection
        firstItem.buttons = [button,button2]
        let firstController = OnBoardingItemView.instance(onBoardingItem: firstItem)
        
        //Set second View
        
        let secondItem = OnBoardingGenericItem()
        secondItem.title = "Tutorial_2_title".localizable
        secondItem.body = "Tutorial_2_message".localizable
        secondItem.imageName = "2tutorial"
        secondItem.texColor = .white
        secondItem.color = UIColor("ACDDF6")
        secondItem.backgroundName = "2tutorial_bg"
        let secondItembutton = OnBoardingGenericButton()
        secondItembutton.text = "Tutorial_2_button1".localizable
        secondItembutton.action = .next
        let secondItembutton2 = OnBoardingGenericButton()
        secondItembutton2.text = "Tutorial_2_button2".localizable
        secondItembutton2.action = .goToSection
        secondItem.buttons = [secondItembutton,secondItembutton2]
        
                let secondController = OnBoardingItemView.instance(onBoardingItem: secondItem)
        
        //Set third View
        
        let thirdItem = OnBoardingGenericItem()
        thirdItem.title = "Tutorial_3_title".localizable
        thirdItem.body = "".localizable
        thirdItem.imageName = "3tutorial"
        thirdItem.texColor = .white
        thirdItem.color = UIColor("007287")
        thirdItem.backgroundName = "3tutorial_bg"
        let thirdItembutton = OnBoardingGenericButton()
        thirdItembutton.text = "Tutorial_3_button1".localizable
        thirdItembutton.action = .next
        let thirdItembutton2 = OnBoardingGenericButton()
        thirdItembutton2.text = "Tutorial_3_button1".localizable
        thirdItembutton2.action = .goToSection
        thirdItem.buttons =  [thirdItembutton2]
       
        let thirdController = OnBoardingItemView.instance(onBoardingItem: thirdItem)
        
        
        
        //Set fourth View
        var vcs = [firstController,secondController,thirdController]
        
//        if !AppManager.shared.inReview {
//            vcs.append(Item5Controller)
//        }
//        vcs.append(Item6Controller)
        
        return vcs
        
    }
    
    static func getControllers(items: [OnBoardingGenericItem]) -> [OnBoardingBaseViewController] {
       
        var list: [OnBoardingBaseViewController] = []
        
        for item in items {
            let vc = OnBoardingItemView.instance(onBoardingItem: item)
            list.append(vc)
        }
        
        return list
        
    }
    
    
    static var controllersDevices : [TutorialSplit] {
        
        
        let items = controllers
        
        var vcs: [TutorialSplit] = []
        
        for item in items {
            let onBorardingItem = item.onBoardingItem
            var ts = TutorialSplit(textColor: Color( onBorardingItem?.texColor ?? .primaryColor), title: onBorardingItem?.title ?? "", text: onBorardingItem?.body ?? "", icon: onBorardingItem?.imageName ?? "", color: Color( onBorardingItem?.color ?? .secondaryColor))
            ts.animation = onBorardingItem?.animationName
            ts.backgroundImg = onBorardingItem?.backgroundName
            vcs.append(ts)
            
        }
        return vcs
        
    }
}

