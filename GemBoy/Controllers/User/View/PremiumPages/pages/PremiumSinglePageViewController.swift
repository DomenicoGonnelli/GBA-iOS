

import Foundation
import UIKit
import Lottie
import Kingfisher

class PremiumSinglePageViewController: UIViewController {
    
    static var identifier = "PremiumSinglePageViewController"
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helmet: UIImageView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceLabelDiscount: UILabel!
    @IBOutlet weak var priceLabelDiscountView: UIView!
    @IBOutlet weak var priceLabelPeriod: UILabel!
    @IBOutlet weak var subscriptionLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var subscriptionButton: UIButton!
    @IBOutlet weak var roundedView: DynamicView!
    
    var item : PremiumSubscriptionModel?
    var lineSpace: CGFloat = 6
    var controller: PremiumSubscriptionPagerViewController?
    var isActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        if let imageUrl = item?.helmetLink, let url = URL(string: imageUrl) {
            helmet.kf.setImage(with: url, completionHandler:  { result in
                let imageResult = try? result.get().image
                self.helmet.image = imageResult
                
            })
        }
                               
        if let imageUrl = item?.backgroundLink, let url = URL(string: imageUrl) {
            bg.kf.setImage(with: url, completionHandler:  { result in
                let imageResult = try? result.get().image
                self.bg.image = imageResult
                self.bg.blurEffect()
                self.bg.alpha = CGFloat(self.item?.alphaBg ?? 35)/100
            })
        }
        
        subscriptionLabel.localizedKey = item?.subscriptionName
        priceLabelPeriod.localizedKey = item?.period
        subscriptionButton.localizedKey = String(format: "subscriptionIdButton".localizable, item?.subscriptionId ?? "")
        
        if let id = item?.iosKeyShort {
            priceLabel.text = AppManager.shared.getProduct(productId: id)?.premiumProductPrize
            
            if let period = item?.periodMonth {
                if period == 1 {
                    priceLabelDiscountView.isHidden = true
                    priceLabelDiscount.text = ""
                } else {
                    priceLabelDiscount.text = AppManager.shared.premiumProduct?.premiumValueMultiplier(value: period)
                }
                
            }
        }
        
        refreshView(isNew: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.helmet.transform = self.roundedView.transform.scaledBy(x: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                self.helmet.transform = CGAffineTransform.identity
            })
        })
        refreshView(isNew: false)
        
    }
    
    func refreshView(isNew: Bool){
        let user = LoginManager.shared.user
        expirationLabel.isHidden = true
        if user?.isPremium == true{
            if user?.premium?.iosKeyShort == item?.iosKeyShort {
                if isNew {
                    startAnimation()
                }
                subscriptionButton.backgroundColor = .white
                subscriptionButton.setTitleColor(.primaryColorFix, for: .normal)
                subscriptionButton.localizedKey = "subscribedPremium"
                isActive = true
                if let exp = user?.premium?.expirationDate {
                    expirationLabel.isHidden = false
                    expirationLabel.localizedKey = String(format: "expirationPremiumLabel".localizable, exp.toLongLabel())
                }
            } else {
                subscriptionButton.isHidden = true
            }
        } else {
//            if let up = user?.premiumSubscription?.periodMonth, let ip = item?.periodMonth{
//                subscriptionButton.isHidden = true
//            }
        }
    }
    
    func setView(){
        tableView.reloadData()
    }
    
    @IBAction func selectSubscription(_ sender: Any) {
        if !isActive {
            controller?.controller?.subscribe_premium(selectedSubscription: item)
        }
    }
    
    var timer : Timer?
    
    private func startAnimation() {
        var progress: CGFloat = 0
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            progress += 0.1
            self.transformPriceTagView(progress: progress)
            
            if progress > 4 {
                self.timer?.invalidate()
            }
        }
    }
    
    
    private func transformPriceTagView(progress: CGFloat) {
        let angle = .pi * progress
        var transform = CATransform3DIdentity
        transform.m34 = -0.001
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        roundedView.layer.transform = transform
    }
}

extension PremiumSinglePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.benefits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PremiumPointCell.identifier, for: indexPath) as! PremiumPointCell
        cell.benefit = item?.benefits[indexPath.row]
        return cell
    }
}



extension PremiumSinglePageViewController {
    static func instance(item: PremiumSubscriptionModel, controller: PremiumSubscriptionPagerViewController?) -> PremiumSinglePageViewController{
        let vc = UIStoryboard(name: "PremiumSinglePage", bundle: nil).instantiateViewController(withIdentifier: identifier) as! PremiumSinglePageViewController
        vc.item = item
        vc.controller = controller
        return vc
    }
}
