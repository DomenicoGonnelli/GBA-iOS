//
//  PremiumUserDetailViewController.swift
//  Project
//
//  Created by EGONNEDGJ on 12/03/23.
//

import Foundation
import UIKit
import Lottie

class PremiumUserDetailViewController: BaseViewController {
    
    static var identifier = "PremiumUserDetailViewController"
    
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var priceAnnual: UILabel!
    @IBOutlet weak var priceMonthlyTotal: UILabel!
    @IBOutlet weak var priceMonthlyTotalDiscount: UIView!
    @IBOutlet weak var priceMonthlylabel: UILabel!
    @IBOutlet weak var priceAnnuallabel: UILabel!
    @IBOutlet weak var annualReniewDate: UILabel!
    
    
    
    @IBOutlet weak var premiumMonthlyView: UIView!
    @IBOutlet weak var premiumAnnualView: UIView!
    @IBOutlet weak var premiumView: UIView!
    
    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var premiumType : PremiumStatus = .noPremium
    var selectedPremiumType : PremiumStatus = .noPremium
    
    var premiumData : [PremiumPoints] = []
    
    override func viewDidLoad() {
        isToPresent = true
        super.viewDidLoad()
        updateView()
    
    }
    
    func updateView(){
        if let user = LoginManager.shared.user {
            premiumType = user.premiumState
            configurePremium(state: premiumType)
            setPrices()
            setAnimation()
            premiumData = []
            premiumData.append(.noAds)
            if !AppManager.shared.inReview {
                premiumData.append(.moreMoney)
            }
            if AppManager.shared.homeData?.liveConfig?.isEnabled == true {
                premiumData.append(.liveRaces)
            }
            premiumData.append(.changeTeam)
            premiumData.append(.leagueCreation)
            
            tableView.reloadData()
        }
        
        if let premiumLastDate = AppManager.shared.homeData?.premiumConfig?.annualExpirationDate?.toLongLabel() {
            annualReniewDate.localizedKey = String(format: "premiumAnnualExpirationLabel".localizable, premiumLastDate)
        }
    }
    
    func callServices(){
        showLoader()
        LoginService.getUser(){_ in
            self.hideLoader()
            self.updateView()
        }
    }
    
    func setPrices(){
        if let productMonthly = AppManager.shared.premiumProductPrize,
        let productAnnual = AppManager.shared.annualProductPrize,
        let productMonthlyForYear = AppManager.shared.premiumProductPrizeAllMonth {
            price.text = productMonthly
            priceAnnual.text = productAnnual
            priceMonthlyTotal.text = productMonthlyForYear
            if premiumType == .annualPremium {
                premiumMonthlyView.superview?.isHidden = true
            } else if premiumType == .monthlyPremium {
                premiumAnnualView.superview?.isHidden = true
            }
        }
    }
    
    func configurePremium(state: PremiumStatus) {
        premiumMonthlyView.backgroundColor = .lightGray
        price.textColor = .primaryColorFix
        priceMonthlylabel.textColor = .primaryColorFix
        
        premiumAnnualView.backgroundColor = .lightGray
        priceAnnual.textColor = .primaryColorFix
        priceMonthlyTotal.textColor = .primaryColorFix
        priceMonthlyTotalDiscount.backgroundColor = .primaryColorFix
        priceAnnuallabel.textColor = .primaryColorFix
        annualReniewDate.textColor = .primaryColorFix
        
        switch state {
        case .noPremium:
            selectedPremiumType = .annualPremium
            premiumAnnualView.backgroundColor = .secondaryColor
            priceAnnual.textColor = .white
            priceMonthlyTotal.textColor = .white
            priceMonthlyTotalDiscount.backgroundColor = .white
            priceAnnuallabel.textColor = .white
            annualReniewDate.textColor = .white
            premiumButton.localizedKey = "premiumPageBecamePremium"
        case .monthlyPremium, .threemonth:
            selectedPremiumType = .monthlyPremium
            premiumMonthlyView.backgroundColor = .secondaryColor
            price.textColor = .white
            priceMonthlylabel.textColor = .white
            premiumButton.localizedKey = premiumType == .noPremium ? "premiumPageBecamePremium" : premiumType == .expired ? "monthlyPremiumReniew" : "premiumPageClose"
        case .annualPremium:
            selectedPremiumType = .annualPremium
            premiumAnnualView.backgroundColor = .secondaryColor
            priceAnnual.textColor = .white
            priceMonthlyTotal.textColor = .white
            priceMonthlyTotalDiscount.backgroundColor = .white
            priceAnnuallabel.textColor = .white
            annualReniewDate.textColor = .white
            premiumButton.localizedKey = premiumType == .noPremium ? "premiumPageBecamePremium" : premiumType != .annualPremium ? "annualPremiumButton" : "premiumPageClose"
        case .expired:
            premiumMonthlyView.backgroundColor = .secondaryColor
            price.textColor = .white
            priceMonthlylabel.textColor = .white
            selectedPremiumType = .monthlyPremium
            premiumButton.localizedKey = "monthlyPremiumReniew"
        }
    }
    
    @IBAction func selectMonthlyPremium() {
        selectedPremiumType = .monthlyPremium
        configurePremium(state: .monthlyPremium)
    }
    
    @IBAction func selectAnnualPremium() {
        selectedPremiumType = .annualPremium
        configurePremium(state: .annualPremium)
    }
    
    
    func setAnimation(){
        let animationName = "stars"
        let animation = LottieAnimation.named(animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animation = animation
        animationView.animationSpeed = 1
        animationView.play()
    }
    
    @IBAction func buttonPressed (_ sender: Any){
        
        if selectedPremiumType == premiumType {
            self.dismiss(animated: true)
        } else {
            var product = selectedPremiumType == .annualPremium ? AppManager.shared.premiumProductAnnual : AppManager.shared.premiumProduct
            
            if IAPHelper.canMakePayments(), let product = product{
                showLoader()
                IAPProduct.store.buyProduct(product)
            } else {
                showAlert(alertTypology: .genericError)
            }
        }
    }
}


extension PremiumUserDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return premiumData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PremiumPointCell.identifier, for: indexPath) as! PremiumPointCell
        cell.premium = premiumData[indexPath.row]
        return cell
    }
}

extension PremiumUserDetailViewController {
    
    static func instance() -> PremiumUserDetailViewController{
        let vc = UIStoryboard(name: "PremiumUserDetail", bundle: nil).instantiateViewController(withIdentifier: identifier) as! PremiumUserDetailViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func present(prensenter: UIViewController?) {
        let vc = instance()
        prensenter?.present(vc, animated: true)
    }
    
    static func push(prensenter: UIViewController?) {
        let vc = instance()
        prensenter?.navigationController?.pushViewController(vc, animated: true)
    }
}
