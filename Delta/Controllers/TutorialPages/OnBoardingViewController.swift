//
//  OnBoardingViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 12/01/23.
//

import Foundation
import UIKit
import Kingfisher

class OnBoardingViewController : UIViewController, OnBoardingPagerDelegate{
    
    static var identifier = "OnBoardingViewController"
    
    @IBOutlet var buttonList: [OnBoardingBorderedButton]!
    @IBOutlet weak var backgorundImage: UIImageView!
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var titleLabel : UILabel!
    
    var pager : OnBoardingPagerViewController?
    var controller: UIViewController?
    
    var controllers : [OnBoardingBaseViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.localizedKey = controllers == nil ? "RulesTitle" : "WhatNewsTitle"
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pager = segue.destination as? OnBoardingPagerViewController{
            pager.controller = self
            pager.pageControl = pageControl
            pager.orderedViewControllers = controllers ?? OnBoardingDataSource.controllers
            self.pager = pager
        }
    }
    
    func setOnBoardingItem(_ item: OnBoardingGenericItem?) {
        onBoardingItem = item
        
        if let img = onBoardingItem?.backgroundName {
            backgorundImage.image = UIImage(named: img)
            titleLabel.textColor = onBoardingItem?.texColor
        }
        
        if let backgroundName = onBoardingItem?.backgroundName, backgroundName.contains("http"), let url = URL(string: backgroundName) {
            backgorundImage.kf.setImage(with: url)
        }
        
        if let backgroundName = onBoardingItem?.color {
            view.backgroundColor = backgroundName
        }
        
        
    }
    
    func getUrl(for key: String?) -> URL?{
        return nil
    }
    
    var onBoardingItem : OnBoardingGenericItem? {
        didSet{
            buttonList.forEach({$0.isHidden = true})
            
            guard let buttons = onBoardingItem?.buttons else{ return }
            
            for button in buttons {
                var onBoardingButton : OnBoardingBorderedButton?
                
                if let action = button.action, action == .next {
                    onBoardingButton = buttonList[0]
                } else {
                    onBoardingButton = buttonList[1]
                }
                
                
                
                onBoardingButton?.item = button
                onBoardingButton?.isHidden = false
            }
        }
    }
    
    func hideButtons(_ hide: Bool) {
        //only one button - nothing to hide
    }
    
    func enableButton(_ enable: Bool) {
        buttonList.last?.isEnabled = enable
    }
    
    @IBAction func onBoardingButtonAction(_ sender: Any) {
        if let item = sender as? OnBoardingGradientDelegate {
            let action = item.item?.action ?? .notNow
            switch action {
            case .next:
                pager?.moveToNextPage()
            case .goToSection:
                dismiss(animated: true, completion: nil)
            default:
                print("action not added")
            }
        }
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    static func instance(controller: UIViewController) -> OnBoardingViewController{
        let vc = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: identifier) as! OnBoardingViewController
        vc.controller = controller
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func present(presenter: UIViewController, controllers : [OnBoardingBaseViewController]? = nil, completion: (() -> Void)? = nil){
        let vc = instance(controller: presenter)
        vc.controllers = controllers
        presenter.present(vc, animated: true, completion: completion)
    }
}
