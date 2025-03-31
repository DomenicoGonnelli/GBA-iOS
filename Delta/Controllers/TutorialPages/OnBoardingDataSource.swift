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
        firstItem.color = .secondaryColor//  UIColor("222F5B")
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
        secondItem.texColor = .primaryColorFix
        secondItem.backgroundName = "2tutorial_bg"
        let secondItembutton = OnBoardingGenericButton()
        secondItembutton.text = "Tutorial_2_button1".localizable
        secondItembutton.action = .next
        let secondItembutton2 = OnBoardingGenericButton()
        secondItembutton2.text = "Tutorial_2_button2".localizable
        secondItembutton2.action = .goToSection
        secondItem.buttons = [secondItembutton,secondItembutton2]
        
        secondItem.color = .secondaryColor//  UIColor("C7446B")
        let secondController = OnBoardingItemView.instance(onBoardingItem: secondItem)
        
        //Set third View
        
        let thirdItem = OnBoardingGenericItem()
        thirdItem.title = "Tutorial_3_title".localizable
        thirdItem.body = "".localizable
        thirdItem.imageName = "3tutorial"
        thirdItem.texColor = .white
        thirdItem.backgroundName = "3tutorial_bg"
        let thirdItembutton = OnBoardingGenericButton()
        thirdItembutton.text = "Tutorial_3_button1".localizable
        thirdItembutton.action = .next
        let thirdItembutton2 = OnBoardingGenericButton()
        thirdItembutton2.text = "Tutorial_3_button2".localizable
        thirdItembutton2.action = .goToSection
        thirdItem.buttons =  [thirdItembutton,thirdItembutton2]
        thirdItem.color = .secondaryColor//  UIColor("F8BD56")
        let thirdController = OnBoardingItemView.instance(onBoardingItem: thirdItem)
        
        let fourthItem = OnBoardingGenericItem()
        fourthItem.title = "Tutorial_4_title".localizable
        fourthItem.body = "".localizable
        fourthItem.imageName = "4tutorial"
        fourthItem.texColor = .white
        fourthItem.backgroundName = "4tutorial_bg"
        let fourthItembutton = OnBoardingGenericButton()
        fourthItembutton.text = "Tutorial_4_button1".localizable
        fourthItembutton.action = .next
        let fourthItembutton2 = OnBoardingGenericButton()
        fourthItembutton2.text = "Tutorial_4_button2".localizable
        fourthItembutton2.action = .goToSection
        fourthItem.buttons =  [fourthItembutton, fourthItembutton2]
        fourthItem.color = .secondaryColor//  UIColor("F8BD56")
        let fourthController = OnBoardingItemView.instance(onBoardingItem: fourthItem)
        
        let Item5 = OnBoardingGenericItem()
        Item5.title = "Tutorial_5_title".localizable
        Item5.body = "Tutorial_5_message".localizable
        Item5.imageName = "5tutorial"
        Item5.texColor = .primaryColorFix
        Item5.backgroundName = "5tutorial_bg"
        let Item5button = OnBoardingGenericButton()
        Item5button.text = "Tutorial_5_button1".localizable
        Item5button.action = .next
        let Item5button2 = OnBoardingGenericButton()
        Item5button2.text = "Tutorial_5_button2".localizable
        Item5button2.action = .goToSection
        Item5.buttons =  [Item5button,Item5button2]
        Item5.color = .secondaryColor//  UIColor("F8BD56")
        let Item5Controller = OnBoardingItemView.instance(onBoardingItem: Item5)
        
        let Item6 = OnBoardingGenericItem()
        Item6.title = "Tutorial_6_title".localizable
        Item6.body = "Tutorial_6_message".localizable
        Item6.imageName = "6tutorial"
        Item6.texColor = .primaryColorFix
        Item6.backgroundName = "6tutorial_bg"
        let Item6button = OnBoardingGenericButton()
        Item6button.text = "Tutorial_6_button1".localizable
        Item6button.action = .goToSection
        Item6.buttons =  [Item6button]
        Item6.color = .secondaryColor//  UIColor("F8BD56")
        let Item6Controller = OnBoardingItemView.instance(onBoardingItem: Item6)
        
        //Set fourth View
        var vcs = [firstController,secondController,thirdController,fourthController]
        
        if !AppManager.shared.inReview {
            vcs.append(Item5Controller)
        }
        vcs.append(Item6Controller)
        
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

