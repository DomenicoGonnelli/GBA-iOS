//
//  BaseViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//

import UIKit
import Lottie
import GoogleMobileAds
import LocalAuthentication
import UserMessagingPlatform

class BaseViewController: UIViewController, AlertViewDelegate {
    
    @IBOutlet weak var navigationBar : CustomNavigationBar?
    @IBOutlet weak var scrollViewBaseHeigth: NSLayoutConstraint?
    @IBOutlet weak var scrollView: UIScrollView?
    
    @IBOutlet weak var shareView: UIView?
    @IBOutlet weak var shareViewDark: UIView?
    @IBOutlet weak var instagramView: UIView?
    @IBOutlet var socialButton: [UIButton]!
    
    var loader : Loader?
    var hideKeyboardGR: UITapGestureRecognizer?
    var activeField: UIView?
    var internalView : UIView?
    var canManageNotification = false
    var keyboardDelegate : KeyboardDelegate?
    var isToPresent = false
    var enableBack = true
    var isShowed: Bool = false
    var alertView: AlertView?
    var interstitial: GADRewardedAd?
    var isAdbPressd = false
    var autorefrashInterstial = true
    var social =  SharingHelper.avaiableSocials()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        enableBackGesture()
        loader?.isHidden = true
        shareView?.isHidden = true
        instagramView?.isHidden = !Social.instagram.isAvailable
    }
    
    func manageNotifition(){
        if canManageNotification {
            NotificationManager.shared.notificationHandler = { [weak self] in
                DispatchQueue.main.async {
                    guard let weakSelf = self else { return }
                    weakSelf.showNotificationIfNeeded()
                }
            }
        }
    }
    
    func restartApp(){
        NotificationManager.shared.scheduleNotification(notification: .newConfiguration)
        exit(0)
    }

    
    func enableBackGesture(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enableBack
    }
    
    func setNavigationBar(){
        navigationBar?.controller = self
        if isToPresent {
            navigationBar?.backImage.isHidden = true
            navigationBar?.backButton.isEnabled = false
            navigationBar?.rightImage.image = UIImage(named: "close")
        } else {
            navigationBar?.rightImage.isHidden = true
        }
    }
    
    func showLoader(bg: UIColor = .clear){
        
        if self.loader == nil {
            self.loader = Loader.createLoader(viewController: self, backgroundColor: bg)
            self.view.isUserInteractionEnabled = false
            self.loader?.isHidden = false
            self.loader?.startAnimation()
        }
        
    }
    
    func actionAfterLoadingInterstitial(){
        
    }
    
    func hideLoader(){
        DispatchQueue.main.async { [weak self] in
            self?.view.isUserInteractionEnabled = true
            self?.loader?.removeFromSuperview()
            self?.loader?.stopAnimation()
            self?.loader?.isHidden = true
            self?.loader = nil
        }
    }
    
    func showAlert(alertTypology: AlertViewTypology){
        
        if alertView == nil {
            DispatchQueue.main.async { [weak self] in
                self?.alertView = AlertView.createAlert(viewController: self)
                self?.alertView?.alertType = alertTypology
                self?.alertView?.delegate = self
                self?.alertView?.isHidden = false
            }
        } else {
            alertView?.alertType = alertTypology
            alertView?.delegate = self
        }
    }
    
    func removeAlert(){
        self.alertView?.removeView(){
            self.alertView?.removeFromSuperview()
            self.alertView = nil
        }
    }
    
    func firstButtonAction(_ type: AlertViewTypology?) {
        if type == .needLogin || type == .retryFaceID{
           
            LoginManager.shared.logout(){ logout in
                if type == .retryFaceID {
                    LoginManager.isFaceIDEnabled = false
                }
                self.goToLogin()
            }
        }
        
        if type == .faceIdUnavailable {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        } else {
            removeAlert()
        }
    }
    
    func secondButtonAction(_ type: AlertViewTypology?) {
        if type == .faceIdUnavailable {
            LoginManager.shared.logout(){ logout in
                LoginManager.isFaceIDEnabled = false
                self.goToLogin()
            }
        } else {
            removeAlert()
        }
    }
    
   private func showNotificationIfNeeded(forceShowing: Bool = true){
        if let notification = NotificationManager.shared.notificationToShow, NotificationManager.shared.hasToShowNotification && forceShowing{
            NotificationManager.shared.hasToShowNotification = false
            self.showNotification(notification: notification)
        } else {
            let dynamicLinksType = DynamicLinksHelper.shared.dynamicLink
            self.managerDynamicLinkAction(action: dynamicLinksType)
        }
    }
    
    private func showNotification(notification: PushNotification, callReadNotification: Bool = true, onNewWindow: Bool = true){
        guard let action = notification.action else { return }
        
//        if let vc = self as? HomePageViewController{
//            switch action {
//            case .classification:
//                vc.controller?.goToClassificationPage()
//            case .home:
//                vc.controller?.goToHomePage()
//            case .createTeam:
//                print("nothingToDo")
//            case .userProfile:
//                vc.controller?.goToHomePage()
//            case .lastEvening:
//                vc.controller?.goToClassificationPage()
//            case .voucher:
//                vc.controller?.goToWalletPage()
//            case .null:
//                print("nothingToDo")
//            case .openQuiz:
//                vc.controller?.goToQuizPush()
//            }
//        }
    }
    
    private func managerDynamicLinkAction(action: DynamicLinksType){
        
//        if let vc = self as? TabBarItemViewController{
//            switch action {
//            case .null:
//                print("nothingToDo")
//            case .discoverClassification:
//                vc.controller?.goToClassificationPage()
//            case .leaguesAccess:
//                AppManager.setShowLeagues()
//                if let league = self as? LeagueOverviewViewController {
//                    league.checkDLAndCallServices()
//                } else {
//                    vc.controller?.goToLeague()
//                }
//            case .driverInvitation:
//                if LoginManager.shared.team == nil {
//                    vc.controller?.goToCreateTeam();
//                } else {
//                    if let url = DynamicLinksHelper.shared.linkInfo {
//                        DynamicLinksHelper.setStoredLink(link: "")
//                        let code = DynamicLinksHelper.decode(from: url, occorences: 7)
//                        AppManager.friendLink = code
//                        vc.controller?.showAlert(alertTypology: .friendBonusNotAvailable, delegate: vc)
//                    }
//                }
//            }
//        }
    }
    
    
    func rightAction(){
        if isToPresent {
            self.dismiss(animated: true)
        }
    }
    
    func leftAction(){
        navigationController?.popViewController(animated: true)
    }
    
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    // Don't forget to unregister when done
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func refreshHome(){
//        if let vc = navigationController?.viewControllers {
//           if let tb = vc.first(where: {$0 is TabBarViewController}) as? TabBarViewController{
//               tb.refreshHome()
//            }
//        }
    }
    

    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        if let keyboardFrame: NSValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardDelegate?.onKeyBoardAppear(withSize: keyboardRectangle.size)
        }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        scrollView?.contentInset = insets
        scrollView?.scrollIndicatorInsets = insets

        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        
        if let activeFieldPresent = activeField, let internalView = internalView
        {
            
            let y =  view.frame.height - kbSize.height
            let aRect = CGRect(x: 0, y: y, width: view.frame.width, height: kbSize.height)
            var o = internalView.convert(activeFieldPresent.frame, to: view)
            o.origin.y += activeFieldPresent.frame.height
            if (aRect.contains(o.origin))
            {
                let diff = o.origin.y -  aRect.height
                let point = CGPoint(x: 0, y: diff)
                self.scrollView?.setContentOffset(point, animated: true)
            }
        }
    }

    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView?.contentInset = UIEdgeInsets.zero
        scrollView?.scrollIndicatorInsets = UIEdgeInsets.zero
        keyboardDelegate?.onKeyBoardDisappear()
    }
    
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    
    /**
     Gesture recognizer to hide keyboard
     */
    func hideKeyboard() {
        if self.hideKeyboardGR == nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
            self.view.isMultipleTouchEnabled = true
            view.addGestureRecognizer(tap)
            self.hideKeyboardGR = tap
        }
    }
    
    
    func showShareView(){
        guard let instagramView = instagramView, let shareView = shareView else {return}
        
        instagramView.isHidden = !Social.instagram.isAvailable
        let originalRect = shareView.bounds
        let rect = CGRect(x: 0, y: originalRect.y + originalRect.height, width: originalRect.width, height: 0)
        shareView.frame = rect
        shareViewDark?.isHidden = false
        shareView.isHidden = false
        UIView.animate(withDuration: 0.15){
            shareView.frame = originalRect
        }
        if let shareViewDark = shareViewDark {
            view.bringSubviewToFront(shareViewDark)
        }
        
        view.bringSubviewToFront(shareView)
    }
    
//    override func tabBar(_ tabBar: SOTabBar, didSelectTabAt index: Int) {
//        super.tabBar(tabBar, didSelectTabAt: index)
//        setNeedsStatusBarAppearanceUpdate()
//        hideQuizView()
//    }

    @IBAction func hideShareView(_ sender: Any){
        guard let originalRect = shareView?.bounds else {return}
        var rect = CGRect(x: 0, y: originalRect.y + originalRect.height, width: originalRect.width, height: 0)

        UIView.animate(withDuration: 0.5){
            self.shareView?.frame = rect
            self.shareView?.isHidden = true
            self.shareViewDark?.isHidden = true
        }
    }
    
    @IBAction func shareWithSocial(_ sender: UIButton){
//        if let index = socialButton?.firstIndex(of: sender){
//            if index < social.count {
//                let instagram = AppManager.shared.homeData?.socialConfig?.instagramPageName ?? "formulafantasyApp"
//                let name = AppManager.shared.homeData?.iosConfig?.appName ?? "Formula Fantasy"
//                let shareMessage = String(format: "shareMessage".localizable, name, "@\(instagram)", AppManager.shared.webUrl)
//                hideShareView(self)
//                SharingHelper.share(social: social[index], subject: name, text: shareMessage, image: sharingImage(position: LoginManager.shared.teamPosition), vc: self){ success in
//                    if success, self.social[index] == .instagram {
//                        InstagramService.getInstagramBonus(){ success in
//                            if success {
//                                self.refreshHome()
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
    }
    
    
    
}


extension BaseViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func addToolbar(textView: UITextView){
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done".localizable, style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
    }
    
    func addToolbar(textView: UITextField){
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done".localizable, style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}

extension BaseViewController: GADFullScreenContentDelegate {
    
    func refreshInterstitial() {
        if LoginManager.shared.user?.isPremium == false {
            showLoader()
            let request = GADRequest()
            
            GADRewardedAd.load(withAdUnitID: AppManager.shared.GADID,
                               request: request,
                               completionHandler: { [self] ad, error in
                self.hideLoader()
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                isAdbPressd = false
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
                self.actionAfterLoadingInterstitial()
            })
        } else {
            self.actionAfterLoadingInterstitial()
        }
    }
    
    
    func showADB(completion: @escaping (()->Void)){
        guard let interstitial = interstitial else {
            completion()
            return
        }
        
        interstitial.present(fromRootViewController: self, userDidEarnRewardHandler: {
            if let vc = self.presentedViewController?.view {
                let viw = UIButton(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400))
                viw.addTarget(self, action: #selector(self.closeAD(_:)), for: .touchUpInside)
                vc.addSubview(viw )
                vc.bringSubviewToFront(viw)
            }
            completion()
        })
    }
    
    @objc func closeAD(_ button: UIButton){
        if !isAdbPressd {
            isAdbPressd = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
                if let vc = self?.presentedViewController{
                    vc.dismiss(animated: true)
                    if self?.autorefrashInterstial == true {
                        self?.refreshInterstitial()
                    }
                }
            }
        }
    }

    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADRewardedInterstitialAd) {
        print("interstitialDidReceiveAd")
    }
    
//    private func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        refreshInterstitial()
//    }
//    
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADRewardedInterstitialAd) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADRewardedInterstitialAd) {
        if self.autorefrashInterstial {
            self.refreshInterstitial()
        }
        print("interstitialWillDismissScreen")
    }
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADRewardedInterstitialAd) {
        print("interstitialWillLeaveApplication")
    }
}


protocol KeyboardDelegate {
    func onKeyBoardAppear(withSize: CGSize)
    func onKeyBoardDisappear()
}

extension BaseViewController {
    func requestConsent() {
        // Carica lo stato del consenso
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: UMPRequestParameters()) { error in
            if let error = error {
                print("Errore nell'aggiornamento del consenso: \(error.localizedDescription)")
                return
            }
            
            // Controlla se il form è disponibile
            if UMPConsentInformation.sharedInstance.formStatus == .available {
                UMPConsentForm.load { form, error in
                    if let error = error {
                        print("Errore nel caricamento del form: \(error.localizedDescription)")
                        return
                    }
                    
                    // Mostra il form del consenso
                    form?.present(from: UIApplication.shared.windows.first!.rootViewController!) { dismissError in
                        if let dismissError = dismissError {
                            print("Errore nella visualizzazione del form: \(dismissError.localizedDescription)")
                        }
                        
                        // Dopo che il form è stato chiuso, verifica lo stato del consenso
                        let consentStatus = UMPConsentInformation.sharedInstance.consentStatus
                        print("Stato del consenso aggiornato: \(consentStatus)")
                    }
                }
            }
        }
    }
    
}
