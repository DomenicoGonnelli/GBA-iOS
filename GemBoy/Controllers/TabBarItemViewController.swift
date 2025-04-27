//
//  TabBarViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//

import Foundation
import UIKit

class TabBarItemViewController: BaseViewController {
    var controller: TabBarViewController?
    var isTrialAccount = false
    
    override func firstButtonAction(_ type: AlertViewTypology?) {
        super.firstButtonAction(type)
        self.controller?.removeAlert()
    }
    
    override func secondButtonAction(_ type: AlertViewTypology?) {
        self.removeAlert()
        self.controller?.removeAlert()
    }
    
    override func showLoader(bg: UIColor = .clear){
        super.showLoader(bg: bg)
        if loader == nil {
            controller?.view.isUserInteractionEnabled = false
        }
    }
    
    override func hideLoader(){
        super.hideLoader()
        DispatchQueue.main.async {
            self.controller?.view.isUserInteractionEnabled = true
        }
        
    }
    
    
}
