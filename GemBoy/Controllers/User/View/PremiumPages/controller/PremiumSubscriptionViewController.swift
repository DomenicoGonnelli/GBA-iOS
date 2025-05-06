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
        
        showLoader(bg: .primaryColorFix)
        
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
        FirestoreHelper.getPremiumrData() { premium in
            let user = LoginManager.shared.user
            self.hideLoader()
            if !isNewSubscription {
                self.pager?.orderedViewControllers = self.subViews
                self.pager?.startView()
            }
            self.pager?.updateView(isNew: isNewSubscription)
            if let id =  user?.premiumSubscription?.subscriptionId, let index = self.subViews.firstIndex(where: {$0.item?.subscriptionId == id}) {
                self.pager?.currentIndex = index
                self.pager?.moveToSpecificPage(nextViewController: self.subViews[index])
            }
        }
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
        
        let p = PremiumUser(value: [:])
        p.iosKey = selectedSubscription?.iosKey
        p.registrationDate = Date()
        
        let oggi = Date()
        if identifier == IAPProduct.premiumAnnual.rawValue, let dataTra12Mesi = Calendar.current.date(byAdding: .month, value: 12, to: oggi) {
            p.expirationDate = dataTra12Mesi
        } else if let dataTra3Mesi = Calendar.current.date(byAdding: .month, value: 3, to: oggi) {
            p.expirationDate = dataTra3Mesi
        }
        self.delegate?.didBecomePremium()
        FirestoreHelper.updatePremiumUsers(user: p)
        AppManager.premiumExpired = false
        self.callServices(isNewSubscription: true)
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
