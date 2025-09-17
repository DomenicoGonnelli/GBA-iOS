
//
//  TabBarViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//


import Foundation
import UIKit
import CircleBar

class TabBarViewController: UIViewController, AlertViewDelegate{

    static let identifier = "TabBarViewController"
    var tabController: SHCircleBarController?
    

    var alertView: AlertView?
    var vc : [UIViewController] = []
    var viewControllers: [UIViewController]?{
        return tabController?.viewControllers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var vc : [UIViewController] = []
        
        
    
        let myBookingListViewController = MyBookingListViewController.instance()
        myBookingListViewController.tabBarItem = UITabBarItem(title: "classificationTab".localizable, image: UIImage(named: "classification"), selectedImage: UIImage(named: "classificationSelected"))
        myBookingListViewController.tabBarItem.badgeColor = .white
        vc.append(myBookingListViewController)
        
    
//
        let home = AliceHomeViewController.instance
        home.tabBarItem = UITabBarItem(title: "homeTab".localizable, image: UIImage(named: "home"), selectedImage: UIImage(named: "homeSelected"))
        home.tabBarItem.badgeColor = .white
        vc.append(home)
        
        
        let userVC = UserProfileViewController.instance2()
        userVC.tabController = self
        userVC.tabBarItem = UITabBarItem(title: "userTab".localizable, image: UIImage(named: "user"), selectedImage: UIImage(named: "userSelected"))
        vc.append(userVC)
        
        
        self.vc = vc
        tabController?.viewControllers = vc
        
    
        self.setNeedsStatusBarAppearanceUpdate()
        self.updateView()
        let bg = UIColor.getGradientColor(startColor: .primaryColorFix, endColor: .secondaryColor, frame: view.frame) ?? .secondaryColor
        self.tabController?.setStarerGraphic(backgrounColor: bg, tintColor: .white, circleColor: .white)
        
        self.updateView()
        self.goToHomePage()
    }
    
    @objc func updateView(){
        tabController?.tabBar.addShadow()
    }
    
    func goToLunch(){
        self.openApp(goOnTabar: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if tabController?.selectedIndex == 2 {
            return .lightContent
        }
        if tabController?.selectedIndex == 0 {
            return .lightContent
        }
        if tabController?.selectedIndex == 4 {
           return .lightContent
        } else {
            return .default
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? SHCircleBarController {
            self.tabController = vc
            vc.viewControllers = self.vc
        }
    }

    
    func showAlert(alertTypology: AlertViewTypology, delegate: AlertViewDelegate?){
        if alertView == nil {
            alertView = AlertView.createAlert(viewController: self)
            alertView?.alertType = alertTypology
            alertView?.delegate = delegate
            alertView?.isHidden = false
        } else {
            alertView?.alertType = alertTypology
            alertView?.delegate = delegate
        }
    }
    
    func removeAlert(){
        self.alertView?.removeView {
            self.alertView?.removeFromSuperview()
            self.alertView = nil
        }
    }
    
    func firstButtonAction(_ type: AlertViewTypology?) {
        removeAlert()
    }
    
    func secondButtonAction(_ type: AlertViewTypology?) {
        removeAlert()
    }
    
    func goToHomePage(){
        if let vc = viewControllers?.first(where: {$0 is AliceHomeViewController}){
            tabController?.selectedViewController = vc
        }
    }
    
//    func refreshHome(){
//        if let userVC = viewControllers?.first(where: {$0 is LaunchViewController}) as? LaunchViewController{
//           
//        }
//    }
//    
//    
//    func goToUsernPage(){
//        if let vc = viewControllers?.first(where: {$0 is UserProfileViewController}),
//           let index = viewControllers?.firstIndex(of: vc) {
//            tabController?.selectedViewController = vc
//        }
//    }
    
    
    static func instance() -> TabBarViewController{
        return UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: identifier) as! TabBarViewController
    }
    
    static func push(from controller: UIViewController?){
        controller?.navigationController?.pushViewController(instance(), animated: false)
    }
       
}


