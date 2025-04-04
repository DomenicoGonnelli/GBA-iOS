//
//  PremiumSubscriptionViewController.swift
//  Project
//
//  Created by Domenico Gonnelli on 21/01/25.
//

import Foundation
import UIKit

class PremiumSubscriptionViewController : BaseViewController, OnPremiumPagerDelegate {
    
    static var identifier = "PremiumSubscriptionViewController"
    
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var titleLabel : UILabel!
    
    var pager : PremiumSubscriptionPagerViewController?
    var delegate: PremiumSubscriptionDelegate?
    var subViews: [PremiumSinglePageViewController] = []
    
    var premiumType : PremiumStatus = .noPremium
    var selectedPremiumType : PremiumStatus = .noPremium
    var selectedSubscription : PremiumSubscriptionModel?
    
    override func viewDidLoad() {
        isToPresent = true
        IAPProduct.store.delegate = self
        super.viewDidLoad()
        
        showLoader(bg: .primaryColor)
        
        PremiumServices.getAllPremium(){ subscriptions in
            for subscription in subscriptions {
                let vc = PremiumSinglePageViewController.instance(item: subscription, controller: self.pager)
                self.subViews.append(vc)
            }
            self.callServices(isNewSubscription: false)
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func callServices(isNewSubscription: Bool){
//        LoginService.getUser(){ user in
//            self.hideLoader()
//            if !isNewSubscription {
//                self.pager?.orderedViewControllers = self.subViews
//                self.pager?.startView()
//            }
//            self.pager?.updateView(isNew: isNewSubscription)
//            if let id =  user?.premiumSubscription?.subscriptionId, let index = self.subViews.firstIndex(where: {$0.item?.subscriptionId == id}) {
//                self.pager?.currentIndex = index
//                self.pager?.moveToSpecificPage(nextViewController: self.subViews[index])
//            }
//        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pager = segue.destination as? PremiumSubscriptionPagerViewController{
            pager.controller = self
            pager.pageControl = pageControl
            self.pager = pager
        }
    }
    

    func subscribe_premium(selectedSubscription: PremiumSubscriptionModel?) {
        if let productID = selectedSubscription?.iosKey, IAPHelper.canMakePayments(), let product = AppManager.shared.getProduct(productId: productID){
            self.selectedSubscription = selectedSubscription
            showLoader()
            IAPProduct.store.buyProduct(product)
        } else {
            showAlert(alertTypology: .genericError)
        }
    }
    
    
    static func instance() -> PremiumSubscriptionViewController{
        let vc = UIStoryboard(name: "PremiumSubscription", bundle: nil).instantiateViewController(withIdentifier: identifier) as! PremiumSubscriptionViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func present(presenter: UIViewController?, delegate: PremiumSubscriptionDelegate?, completion: (() -> Void)? = nil){
        let vc = instance()
        vc.delegate = delegate
        presenter?.present(vc, animated: true, completion: completion)
        
    }
}



extension PremiumSubscriptionViewController: IAPHelperDelegate{
    
    func paymentOk(identifier: String) {
        UserService.becamePremium(trans: identifier, type: selectedSubscription?.subscriptionId){ response in
            self.hideLoader()
            if response {
                self.callServices(isNewSubscription: true)
//                AppManager.setIsNewPremium()
                self.delegate?.didBecomePremium()
                //AppManager.premiumExpired = false
            } else {
                self.showAlert(alertTypology: .genericError)
            }
            
            print("success")
        }
    }
    
    func paymentKO() {
        self.showAlert(alertTypology: .genericError)
        self.hideLoader()
        
    }
    
    func paymentCancel() {
        self.hideLoader()
    }
    
    
}


protocol PremiumSubscriptionDelegate {
    func didBecomePremium()
}
