//
//  AlertView.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//

import Foundation
import UIKit

class AlertView: BaseView{
    
    override var nibName: String?{
        return "AlertView"
    }
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var sadImage : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var actionButton : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    
    var delegate: AlertViewDelegate?
    
    var alertType: AlertViewTypology?{
        didSet{
            if let alert = alertType?.alert {
                setItem(view: sadImage, text: alert.imageName)
                setItem(view: titleLabel, text: alert.title)
                setItem(view: descriptionLabel, text: alert.description)
                setItem(view: actionButton, text: alert.firstButtonTitle)
                setItem(view: cancelButton, text: alert.secondButtonTitle)
                if alertType?.isToDelete == true{
                    actionButton.backgroundColor = .systemRed
                } else {
                    actionButton.backgroundColor = UIColor.secondaryColor
                }
            }
        }
    }
    
    var alert: AlertModel?{
        didSet{
            if let alert = self.alert {
                setItem(view: sadImage, text: alert.imageName)
                setItem(view: titleLabel, text: alert.title)
                setItem(view: descriptionLabel, text: alert.description)
                setItem(view: actionButton, text: alert.firstButtonTitle)
                setItem(view: cancelButton, text: alert.secondButtonTitle)
                actionButton.backgroundColor = UIColor.secondaryColor
            }
        }
    }
    
    private func setItem(view: UIView, text: String?){
        if let text = text {
            if let label = view as? UILabel {
                label.localizedString = text
            } else if let button = view as? UIButton{
                button.localizedString = text
            } else if let imageView = view as? UIImageView{
                imageView.image = UIImage(named: text)
            }
            view.isHidden = false
        } else {
            view.isHidden = true
        }
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        UIView.animate(withDuration: 0.5){
            self.container?.transform = CGAffineTransform.identity
        }
    }
    
    func removeView(completion: @escaping (()->Void)){
        UIView.animate(withDuration: 0.02,
            animations: {
                self.container?.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            },
            completion: { _ in
            completion()
        })
    }
    
    static func createAlert(viewController: UIViewController?, frame: CGRect? = nil) -> AlertView?{
        guard let viewController = viewController else {
            return nil
        }
        let alertView = AlertView.init(frame: frame ?? UIScreen.main.bounds)
        viewController.view.addSubview(alertView)
        viewController.view.bringSubviewToFront(alertView)
        return alertView
    }
    
    @IBAction func firstAction(_ sender: Any){
        delegate?.firstButtonAction(alertType)
    }
    
    @IBAction func secondAction(_ sender: Any){
        delegate?.secondButtonAction(alertType)
    }
    
}

protocol AlertViewDelegate{
   func firstButtonAction(_ type: AlertViewTypology?)
   func  secondButtonAction(_ type: AlertViewTypology?)
}

enum AlertViewTypology {
    case genericError, loginError, logout, noProductsError, accountDeletion, accountDeleted, needLogin, noCorrectUser, videoError, needPremium, needPremiumOrPay, noCameraPermission, faceIdUnavailable, retryFaceID, newConfiguration, noTwitter
    var isToDelete: Bool {
        return self == .logout || self == .accountDeletion || self == .accountDeleted
    }
    
    var alert: AlertModel{
        let newAlert = AlertModel()
        var premiumPrice = AppManager.shared.premiumProductPrize ?? ""
        var changeTeamPrice = ""
        
        switch self {
        case .genericError:
            newAlert.title = "genericErrorTitle".localizable
            newAlert.description = "genericErrorDescription".localizable
            newAlert.firstButtonTitle = "genericErrorButton".localizable
        case .noProductsError:
            newAlert.title = "genericErrorTitle".localizable
            newAlert.description = "genericErrorDescription".localizable
        case .loginError:
            newAlert.title = "loginErrorTitle".localizable
            newAlert.description = "loginErrorDescription".localizable
            newAlert.firstButtonTitle = "loginErrorButton".localizable
        case .logout:
            newAlert.imageName = "logout"
            newAlert.imageColor = .secondaryColor
            newAlert.title = "logoutAlertTitle".localizable
            newAlert.description = "logoutAlertDescription".localizable
            newAlert.firstButtonTitle = "logoutAlertButton".localizable
            newAlert.secondButtonTitle = "logoutAlertCancel".localizable
        case .accountDeletion:
            newAlert.imageName = "deleteAccount"
            newAlert.title = "accountDeletionTitle".localizable
            newAlert.description = "accountDeletionDescription2".localizable
            newAlert.firstButtonTitle = "accountDeletionFirstButton".localizable
            newAlert.secondButtonTitle = "accountDeletionSecondButton".localizable
        case .accountDeleted:
            newAlert.imageName = "deleteAccount"
            newAlert.title = "accountDeletedTitle".localizable
            newAlert.description = "accountDeletedDescription".localizable
            newAlert.firstButtonTitle = "accountDeletedFirstButton".localizable
        case .needLogin:
            newAlert.description = "needLoginDescription".localizable
            newAlert.firstButtonTitle = "noCorrectUserButton".localizable
        case .noCorrectUser:
            newAlert.description = "noCorrectUserTitle".localizable
            newAlert.description = "noCorrectUserDescription".localizable
            newAlert.firstButtonTitle = "noCorrectUserButton".localizable
       
        case .videoError:
            newAlert.description = String(format: "videoErrorAlertDescription".localizable, premiumPrice)
            newAlert.firstButtonTitle = "videoErrorButton".localizable

        case .needPremium:
            newAlert.imageName = "premiumCoins"
            newAlert.title = "needPremiumTitle".localizable
            newAlert.description = "needPremiumDescription".localizable
            newAlert.firstButtonTitle = "needPremiumFirstButton".localizable
            newAlert.secondButtonTitle = "needPremiumSecondButton".localizable
        case .needPremiumOrPay:
            newAlert.imageName = "premiumCoins"
            newAlert.title = "needPremiumOrPayTitle".localizable
            newAlert.description = String(format: "needPremiumOrPayDescription".localizable, changeTeamPrice)
            newAlert.firstButtonTitle = "needPremiumOrPayFirstButton".localizable
            newAlert.secondButtonTitle = String(format: "needPremiumOrPaySecondButton".localizable, changeTeamPrice)
        case .noCameraPermission:
            newAlert.title = "noCameraPermissionErrorTitle".localizable
            newAlert.description = "noCameraPermissionErrorDescription".localizable
            newAlert.firstButtonTitle = "noCameraPermissionErrorButton".localizable
            newAlert.secondButtonTitle = "noCameraPermissionErrorClose".localizable
        case .faceIdUnavailable:
            newAlert.imageName = UserProfileMenuItem.biometricImageName
            newAlert.title = String(format: "faceIdUnavailableAlertTitle".localizable , UserProfileMenuItem.biometricName)
            newAlert.description = String(format: "faceIdUnavailableAlertDescription".localizable , UserProfileMenuItem.biometricName)
            newAlert.firstButtonTitle = "faceIdUnavailableAlertGoSetting"
            newAlert.secondButtonTitle = "faceIdUnavailableAlertGoLogin"
            
        case .retryFaceID:
            newAlert.imageName = UserProfileMenuItem.biometricImageName
            newAlert.title = String(format: "retryFaceIDAlertTitle".localizable , UserProfileMenuItem.biometricName)
            newAlert.description = String(format: "retryFaceIDAlertDescription".localizable , UserProfileMenuItem.biometricName)
            newAlert.firstButtonTitle = "retryFaceIDAlertGoLogin"
            
        case .newConfiguration:
            newAlert.title = "changeConfigurationTitle".localizable
            newAlert.description = "changeConfigurationDescription".localizable
            newAlert.firstButtonTitle = "changeConfigurationButton".localizable
            newAlert.secondButtonTitle = "changeConfigurationButton2".localizable
            
        case .noTwitter:
            newAlert.imageName = "TwitterLogin"
            newAlert.title = "TwitterLoginErrroTitle".localizable
            newAlert.description = "TwitterLoginErrroMessage".localizable
            newAlert.firstButtonTitle = "TwitterLoginErrroButton".localizable
        }
        
        return newAlert
    }
}
