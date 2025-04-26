//
//  StatisticsViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 13/01/23.
//

import Foundation
import UIKit

class StatisticsUserViewController: BaseViewController {
    
    static let identifier = "StatisticsUserViewController"
    
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    
    @IBOutlet weak var premiumUser: UIButton!
    
    @IBOutlet weak var deleteTeamButton: UIView!
    
    @IBOutlet weak var premiumUserImage: UIImageView!
    @IBOutlet weak var profileUserImage: UIImageView!
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var controller: BaseViewController?
    var tabController: TabBarViewController?
    var enableButton: Bool = true{
        didSet{
            premiumUserImage.isHidden = enableButton
            premiumUser.localizedKey = enableButton ? "premiumPageBecamePremium" : "premiumPageBecamePremiumDetail"
        }
    }
    
    override func viewDidLoad() {
        isToPresent = true
        autorefrashInterstial = false
        super.viewDidLoad()
        guard let _ = LoginManager.shared.user else {
            self.showAlert(alertTypology: .genericError)
            return
        }

        setNeedsStatusBarAppearanceUpdate()
    }
    
    func setString(show: Bool = false){
        if show {
            showLoader()
        }
        userInfoLabel.text = "Games: 0\nSaved Games: 0\nOnline Games: 0\nMedals: 0"
        
//        self.enableButton = LoginManager.shared.user?.isPremium == false
//        self.deleteTeamButton.isHidden = true
//        if let team = LoginManager.shared.user?.team {
//            self.deleteTeamButton.isHidden = AppManager.shared.firstEventStarted
//        }
//        self.userInfoLabel.attributedText = nil
//        self.userTitleLabel.attributedText = nil
//        let user = LoginManager.shared.user
//        let remainingMoney = "\(user?.team?.remaingingMoney ?? AppManager.shared.totalFantaMoney())"
//        let fantaPoints = LoginManager.shared.totalFantaPointsString
//        let wallet = ""
//        let classification = LoginManager.shared.teamPosition >= 0 ? "\(LoginManager.shared.teamPosition + 1)°" : "-"
//        self.userTitleLabel.setAttributedWithTag(text: "UserProfileMessage".localizable, boldSize: 24)
//        self.userInfoLabel.setAttributedWithTag(text: String(format: "UserProfileMessage2".localizable, user?.team?.teamName ?? "-", remainingMoney,fantaPoints,classification, wallet), boldSize: 24)
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setString()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    
    static func instance() -> StatisticsUserViewController{
        let vc = UIStoryboard(name: "StatisticsUser", bundle: nil).instantiateViewController(withIdentifier: identifier) as! StatisticsUserViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func present2(prensenter: BaseViewController) {
        let vc = instance()
        vc.controller = prensenter
        prensenter.present(vc, animated: true)
    }

    
}


extension StatisticsUserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Medals.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MedalsCollectionViewCell.identifier, for: indexPath) as! MedalsCollectionViewCell
        
        let item = Medals.allCases[indexPath.row]
        cell.configure(medal: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let item = Medals.allCases[indexPath.row]
        showAlert(alert: item.alert)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.height - 60
        
        let witdht = height * 2/3
        
        return CGSize(width: witdht, height: height)
    }
    
}
