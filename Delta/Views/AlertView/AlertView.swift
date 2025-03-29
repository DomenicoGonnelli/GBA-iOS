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
                container?.transform.scaledBy(x: 0.1, y: 0.1)
                if alertType?.isToDelete == true{
                    actionButton.backgroundColor = .systemRed
                } else {
                    actionButton.backgroundColor = UIColor.secondaryColor
                }
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
    
    static func createAlert(viewController: UIViewController?) -> AlertView?{
        guard let viewController = viewController else {
            return nil
        }
        let alertView = AlertView.init(frame: viewController.view.frame)
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
    case genericError, loginError, logout, noProductsError, accountDeletion, accountDeleted, needLogin, noCorrectUser, teamCreation, videoError, videoErrorReview, teamDeletion, notOnFirst, noWinVoucher, noTeamAvailable, noQuizAvailable, needPremium,needPremiumOrPay, voucherGeneration, noCameraPermission, leagueCreation, notValidQRCode, addedQRCode, leaveLeague, needTeam, removeFromLeague, completed, friendBonusNotAvailable, friendBonusActive, noFriendsInvited, faceIdUnavailable, retryFaceID, newConfiguration, noTwitter
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
        case .teamCreation:
            newAlert.imageName = "premiumCoins"
            newAlert.title = "teamCreationAlertTitle".localizable
            newAlert.description = String(format: "teamCreationAlertDescription".localizable, premiumPrice)
            newAlert.firstButtonTitle = "teamCreationlertButton".localizable
            newAlert.secondButtonTitle = "teamCreationAlertCancel".localizable
        case .videoError:
            newAlert.description = String(format: "videoErrorAlertDescription".localizable, premiumPrice)
            newAlert.firstButtonTitle = "videoErrorButton".localizable
        case .videoErrorReview:
            newAlert.description = String(format: "videoErrorAlertDescriptionReview".localizable, premiumPrice)
            newAlert.firstButtonTitle = "videoErrorButton".localizable
        case .teamDeletion:
            newAlert.imageName = "deleteAccount"
            newAlert.title = "teamDeletionTitle".localizable
            newAlert.description = String(format: "teamDeletionDescription2".localizable, "_")
            newAlert.firstButtonTitle = "teamDeletionFirstButton".localizable
            newAlert.secondButtonTitle = "teamDeletionSecondButton".localizable
        case .notOnFirst:
            newAlert.imageName = "notOnFirst"
            newAlert.title = "notOnFirstTitle".localizable
            newAlert.description = String(format: "notOnFirstDescription".localizable, "_")
            newAlert.firstButtonTitle = "notOnFirstFirstButton".localizable
        case .noWinVoucher:
            newAlert.imageName = "amazon"
            newAlert.title = "noWinVoucherTitle".localizable
            newAlert.description = "noWinVoucherDescription".localizable
            newAlert.firstButtonTitle = "noWinVoucherButton".localizable
        case .noTeamAvailable:
            newAlert.title = "noTeamAvailableTitle".localizable
            newAlert.description = "noTeamAvailablerDescription".localizable
            newAlert.firstButtonTitle = "noTeamAvailableButton".localizable
        case .noQuizAvailable:
            newAlert.imageName = "noQuiz"
            newAlert.imageColor = .secondaryColor
            newAlert.title = "noQuizAvailableTitle".localizable
            newAlert.description = "noQuizAvailableDescription".localizable
            newAlert.firstButtonTitle = "noQuizAvailableFirstButton".localizable
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
        case .voucherGeneration:
            newAlert.imageName = "amazon"
            newAlert.title = "voucherGenerationTitle".localizable
            newAlert.description = "voucherGenerationDescription".localizable
            newAlert.firstButtonTitle = "voucherGenerationButtonOk".localizable
            newAlert.secondButtonTitle = "voucherGenerationButtonCancel".localizable
        case .leagueCreation:
            newAlert.imageName = "leagueIcon"
            newAlert.title = "leagueCreationAlertTitle".localizable
            newAlert.description = "leagueCreationAlertMessage".localizable
            newAlert.firstButtonTitle = "leagueCreationAlertFirstButton".localizable
        case .noCameraPermission:
            newAlert.title = "noCameraPermissionErrorTitle".localizable
            newAlert.description = "noCameraPermissionErrorDescription".localizable
            newAlert.firstButtonTitle = "noCameraPermissionErrorButton".localizable
            newAlert.secondButtonTitle = "noCameraPermissionErrorClose".localizable
        case .notValidQRCode:
            newAlert.title = "notValidQRCodeErrorTitle".localizable
            newAlert.description = "notValidQRCodeErrorDescription".localizable
            newAlert.firstButtonTitle = "notValidQRCodeErrorButton".localizable
        case .addedQRCode:
            newAlert.imageName = "leagueIcon"
            newAlert.title = "addedQRCodeTitle".localizable
            newAlert.description = "addedQRCodeDescription".localizable
            newAlert.firstButtonTitle = "addedQRCodeButton".localizable
        case .leaveLeague:
            newAlert.imageName = "leagueIcon"
            newAlert.title = "leaveLeagueTitle".localizable
            newAlert.description = "leaveLeagueDescription".localizable
            newAlert.firstButtonTitle = "leaveLeagueButton".localizable
            newAlert.secondButtonTitle = "leaveLeagueButtonCancel".localizable
        case .needTeam:
            newAlert.title = "needTeamAlertTitle".localizable
            newAlert.description = "needTeamAlertDescription".localizable
            newAlert.firstButtonTitle = "needTeamAlertButton".localizable
        case .removeFromLeague:
            newAlert.title = "removeFromLeagueTitle".localizable
            newAlert.description = "removeFromLeagueDescription".localizable
            newAlert.firstButtonTitle = "removeFromLeagueButton".localizable
            newAlert.secondButtonTitle = "removeFromLeagueButtonCancel".localizable
        case .completed:
            newAlert.title = "completedActionTitle".localizable
            newAlert.description = "completedActionDescription".localizable
            newAlert.firstButtonTitle = "completedActionButton".localizable
            
        case .friendBonusNotAvailable:
            newAlert.imageName = "trofeo1_win"
            newAlert.title = "friendBonusNotAvailableTitle".localizable
            newAlert.description = "friendBonusNotAvailableDescription".localizable
            newAlert.firstButtonTitle = "friendBonusNotAvailableButton".localizable
        
        case .friendBonusActive:
            newAlert.imageName = "trofeo1_win"
            newAlert.title = "friendBonusAvailableTitle".localizable
            newAlert.description = "friendBonusAvailableDescription".localizable
            newAlert.firstButtonTitle = "friendBonusAvailableButton".localizable
        
        case .noFriendsInvited:
            newAlert.imageName = "trofeo1"
            newAlert.title = "noFriendsInvitedTitle".localizable
            newAlert.description = "noFriendsInvitedDescription".localizable
            newAlert.firstButtonTitle = "noFriendsInvitedButton".localizable
            
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
