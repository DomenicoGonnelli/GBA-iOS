//
//  OnBoardingBaseViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 12/01/23.
//

import Foundation
import UIKit

protocol OnBoardingItemViewProtocol {
    func onLinkTapped(gesture: UITapGestureRecognizer)
}

protocol OnBoardingDelegate {
    func onLinkClicked(with key: String?)
    func enableButton(_ enable: Bool)
}


public class OnBoardingGenericItem: DatabaseModelProtocol {
    var title: String?
    var body: String?
    var linkKey: String?
    var delegate: OnBoardingDelegate?
    var buttons: [OnBoardingGenericButton] = []
    var imageName: String?
    var backgroundName: String?
    var animationName: String?
    var addingValueToFont: CGFloat = 0
    var color: UIColor?
    var texColor: UIColor?
    var version: String?
    
    init() {
        
    }
    
    required init(value: [String : Any]) {
        let lang = DeviceManager.getLang().rawValue
        if let t = value["title"] as? Dictionary<String,Any> {
            title = t[lang] as? String ?? ""
        }
        if let t = value["body"] as? Dictionary<String,Any> {
            body = t[lang] as? String ?? ""
        }
        
        linkKey = value["linkKey"] as? String
        
        buttons = []
        if let buttons = value["buttons"] as? [[String:Any]] {
            for button in buttons {
                self.buttons.append(OnBoardingGenericButton(value: button))
            }
        }
        imageName = value["imageName"] as? String
        backgroundName = value["backgroundName"] as? String
        animationName = value["animationName"] as? String
        version = value["version"] as? String
        
        
        
        if let col = value["color"] as? String {
            color = UIColor(named: col) ?? UIColor(col)
        }
        
        texColor = .primaryColor
        if let col = value["texColor"] as? String {
            texColor = UIColor(named: col) ?? UIColor(col)
        }
        
    }
    
}

public class OnBoardingGenericButton: DatabaseModelProtocol {
    var text: String?
    var action: OnBoardingAction?
    var color: UIColor?
    var textColor: UIColor?
    
    init() {
        
    }
    
    required init(value: [String : Any]) {
        text = value["text"] as? String
        if let action = value["action"] as? String {
            self.action = OnBoardingAction(rawValue: action) ?? .goToSection
        }
        
        
        if let col = value["color"] as? String {
            color = UIColor(named: col) ?? UIColor(col)
        }

        if let col = value["textColor"] as? String {
            textColor = UIColor(named: col) ??  UIColor(col)
        }
    }
    
}

public enum OnBoardingAction: String, CaseIterable{
    case next, goToSection, notNow
}

