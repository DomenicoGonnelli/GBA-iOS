//
//  UserProfileViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 13/01/23.
//

import Foundation
import UIKit
import Kingfisher
import MessageUI

class UserProfileViewController: LoginViewController {
    
    static let identifier2 = "UserProfileViewController"
    
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userTeamButton: UIButton!
    @IBOutlet weak var premiumUserImage: UIImageView!
    
    @IBOutlet weak var tableView: UIView!
    
    @IBOutlet weak var popoverView: UIView!
    @IBOutlet weak var popoverViewBG: UIView!
    @IBOutlet weak var biometricLoginView: UIView!
    @IBOutlet weak var biometricLoginTitle: UILabel!
    @IBOutlet weak var biometricLoginBar: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewContainer: UIView!
    
    @IBOutlet weak var teamDetailViewContainer: UIView!
    @IBOutlet weak var teamDetailLabel: UILabel!
    
    
    var section = UserProfileMenuItem.sections
    var loginController: BaseViewController?
    var selectedItem : UserProfileMenuItem?
    
    
    func setHelmetPremium(){
        if let premium = LoginManager.shared.user?.premium?.type, let helmet = AppManager.shared.premiumSubscriptions.first(where: {$0.subscriptionId == premium})?.helmetLink, let url  = URL(string: helmet) {
            premiumUserImage.kf.setImage(with: url)
        } else {
            premiumUserImage.image = UIImage(named: "defaultPremiumHelmet")
        }
    }
    
    let languages = language.list
    
    var selectedLanguage: language = DeviceManager.getLang()
    
    override func viewDidLoad() {
        isToPresent = true
        super.viewDidLoad()
        guard let _ = LoginManager.shared.user else {
            showAlert(alertTypology: .genericError)
            return
        }
        setString()
        setNeedsStatusBarAppearanceUpdate()
        navigationBar?.rightImageButton = UIImage(named: "menuIcon")
        hidePopover()
        setBiometricViews()
        setupPickerView()
        selectedLanguage = DeviceManager.getLang()
    }
    
    func setBiometricViews(){
        if LoginManager.isFaceIDEnabled {
            biometricLoginTitle.localizedKey = String(format: "userProfileBiometricPageTitleActive".localizable, UserProfileMenuItem.biometricName)
            biometricLoginBar.isHidden = true
        } else {
            biometricLoginTitle.localizedKey = String(format: "userProfileBiometricPageTitleUnactive".localizable, UserProfileMenuItem.biometricName)
            biometricLoginBar.isHidden = false
        }
    }
    
    func hidePopover(){
        pickerViewContainer.isHidden = true
        biometricLoginView.isHidden = true
        teamDetailViewContainer.isHidden = true
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            self.popoverView.transform = CGAffineTransform(translationX: 0, y: self.popoverView.frame.height)
            self.popoverViewBG.isHidden = true
        }
    }
    
    func showPopover(){
        popoverView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            self.popoverView.transform = CGAffineTransform.identity
            self.popoverViewBG.isHidden = false
        }
        
    }
    
    @IBAction func closePopover(_ sender: Any){
        hidePopover()
        hideShareView(self)
    }
    
    override func hideShareView(_ sender: Any) {
        super.hideShareView(sender)
        self.popoverViewBG.isHidden = true
    }
    
    @IBAction func setBiometric(_ sender: Any){
        getFaceID(force: true){ success, enabled in
            if LoginManager.isFaceIDEnabled {
                if success {
                    LoginManager.isFaceIDEnabled = false
                    self.setBiometricViews()
                }
            } else {
                if success {
                    LoginManager.isFaceIDEnabled = true
                    self.setBiometricViews()
                }
                if !enabled {
                    self.showAlert(alertTypology: .faceIdUnavailable)
                }
            }
            
        }
    }
  
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    func setString(){
        setHelmetPremium()
        self.userTitleLabel.attributedText = nil
        let user = LoginManager.shared.user
        self.userTitleLabel.setAttributedWithTag(text: "UserProfileMessage".localizable, boldSize: 28)
    }
    
    override func hideKeyboard() {
        doneButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setString()
    }
    
    override func firstButtonAction(_ type: AlertViewTypology?) {
        if type == .logout {
            LoginManager.shared.logout(){ _ in
                self.dismiss(animated: true){
                    NotificationManager.shared.scheduleNotification(notification: .logoutSuccess)
                    self.controller?.goToLogin()
                    super.firstButtonAction(type)
                }
            }
        } else if type == .accountDeletion{
//            LoginManager.shared.deleteAccount(){ error in
//                if error == .noError {
//                    self.showAlert(alertTypology: .accountDeleted)
//                } else if error == .requireAuth{
//                    self.showAlert(alertTypology: .needLogin)
//                }else {
//                    self.showAlert(alertTypology: .genericError)
//                }
//            }
        } else if type == .accountDeleted || type == .noCorrectUser{
            LoginManager.shared.logout(){ _ in
                self.dismiss(animated: true){
                    self.controller?.firstButtonAction(.genericError)
                    self.controller?.goToLogin()
                    super.firstButtonAction(type)
                }
            }
        } else if type == .needLogin {
            self.newAuthentication(type: LoginManager.shared.user?.loginMode)
        } else if type == .teamCreation {
            if IAPHelper.canMakePayments(), let product = AppManager.shared.products.first{
                showLoader()
                IAPProduct.store.buyProduct(product)
            } else {
                showAlert(alertTypology: .genericError)
            }
            super.firstButtonAction(type)
        } else if type == .teamDeletion{
//            UserService.deleteTeam(){ deleted in
//                if deleted {
//                    NotificationManager.shared.scheduleNotification(notification: .teamDeleted)
//                    self.controller?.refreshHome()
////                    self.deleteTeamButton.isHidden = true
//                    LoginManager.shared.team = nil
//                    self.setString()
//                    
//                } else {
//                    self.showAlert(alertTypology: .genericError)
//                }
//                super.firstButtonAction(type)
//                
//            }
        } else if type == .newConfiguration {
            if selectedItem == .changeLanguage {
                DeviceManager.storeLang(lang: selectedLanguage.rawValue)
            }
            restartApp()
        }
        else {
            super.firstButtonAction(type)
        }
    }
    
    func newAuthentication(type: LoginMode?){
        if type == .google {
            googleReaut()
        } else if type == .apple {
            loginWithApple(self)
        }
    }
    
    func googleReaut(){
        self.loginWithGoogle(){
            self.checkAndDelete()
        }
    }
    
    func checkAndDelete(){
        if LoginManager.shared.user?.loginMode == .apple {
            if self.identificator == LoginManager.shared.user?.identificator {
                self.firstButtonAction(.accountDeletion)
            } else {
                showAlert(alertTypology: .noCorrectUser)
            }
        } else {
//            if self.identificator == Auth.auth().currentUser?.email {
//                self.firstButtonAction(.accountDeletion)
//            } else {
//                showAlert(alertTypology: .noCorrectUser)
//            }
        }
    }
    
    override func appleAuth(idToken: String) {
        checkAndDelete()
    }
    
    override func secondButtonAction(_ type: AlertViewTypology?) {
        super.secondButtonAction(type)
    }
    
    static func instance2() -> UserProfileViewController{
        let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: identifier2) as! UserProfileViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func present2(prensenter: BaseViewController) {
        let vc = instance2()
        vc.loginController = prensenter
        prensenter.present(vc, animated: true)
    }
    static func push2(prensenter: BaseViewController?) {
        let vc = instance2()
        prensenter?.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    
    @IBAction func goPremium(_ sender: Any){
        PremiumSubscriptionViewController.present(presenter: self, delegate: self)
    }
    
}

extension UserProfileViewController: PremiumSubscriptionDelegate {
    func didBecomePremium() {
        print("aggiorna")
    }
}


extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return UserProfileMenuItem.sectionNames[section].localizable
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UserProfileMenuItem.sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section[UserProfileMenuItem.sectionNames[section]]?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileMenuItemCell.identifier, for: indexPath) as! UserProfileMenuItemCell
        let item = self.section[UserProfileMenuItem.sectionNames[indexPath.section]]?[indexPath.row]
        cell.setData(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = self.section[UserProfileMenuItem.sectionNames[indexPath.section]]?[indexPath.row] {
            selectedItem = item
            switch item {
            case .loginMethod:
                print("nothing to do")
            case .biometricLoginTI, .biometricLoginFI:
                biometricLoginView.isHidden = false
                showPopover()
            case .teamDetail:
                teamDetailViewContainer.isHidden = false
                showPopover()
            case .changeLanguage:
                pickerViewContainer.isHidden = false
                showPopover()
                if let i = languages.firstIndex(of: selectedLanguage){
                    pickerView.selectRow(i, inComponent: 0, animated: true)
                }
            case .changePaletteColor:
                ColorPaletteViewController.present(prensenter: self)
            case .instagramPage:
                print("")
//                if let string = AppManager.shared.homeData?.socialConfig?.instagramUrl, let url = URL(string: string){
//                    UIApplication.shared.open(url)
//                }
            case .contactUs:
                sendEmail()
            case .shareApp:
                self.popoverViewBG.isHidden = false
                showShareView()
            case .deleteTeam:
                showAlert(alertTypology: .teamDeletion)
            case .deleteAccount:
                showAlert(alertTypology: .accountDeletion)
            case .logout:
                showAlert(alertTypology: .logout)
            case .push:
                NotificationListViewController.push(prensenter: self)
            case .empty:
                print("nothing to do")
            case .settings:
                SettingsViewController.push(from: self)
            }
        }
    }
}


extension UserProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func setupPickerView() {
        pickerView.backgroundColor = .invertedPrimaryColor
        pickerView.tintColor = .primaryColor
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
    }
    
    @IBAction func doneButtonTapped() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        selectedLanguage = languages[selectedRow]
        print("🌍 Lingua selezionata: \(selectedLanguage.rawValue)")
        saveLanguage(selectedLanguage.rawValue)
        self.popoverViewBG.isHidden = true
        pickerView.removeFromSuperview()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = languages[row].name
        let myTitle = titleData.attributedString(fontStyle: .medium, size: 16, color: .primaryColor)
        myTitle.addAlignment(alignment: .left)
        return myTitle
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return languages[row].name
//    }
    
    func saveLanguage(_ languageCode: String) {
        showAlert(alertTypology: .newConfiguration)
    }
}

extension UserProfileViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            // Mostra un alert o gestisci l'errore se il dispositivo non è configurato per inviare email
            showAlert(alertTypology: .genericError)
            return
        }

        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self

        // Imposta il destinatario invisibile
        mailComposer.setToRecipients(["domenico.gonnelli@outlook.it"])
        // Opzionalmente, puoi impostare un oggetto predefinito
        let id = LoginManager.shared.user?.id ?? ""
        mailComposer.setSubject("Segnalazione utente \(id)")
        
        
        if let email = LoginManager.shared.user?.identificator {
            let lang = DeviceManager.getLang().rawValue
            mailComposer.setMessageBody(String(format: "mailMessageBody".localizable, email,lang), isHTML: true)
        }
        

        // Presenta il mail composer
        self.present(mailComposer, animated: true, completion: nil)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            showAlert(alertTypology: .genericError)
        @unknown default:
            print("Mail sent")
        }

        controller.dismiss(animated: true, completion: nil)
    }

    
}
