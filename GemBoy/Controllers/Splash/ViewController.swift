//
//  ViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import UIKit
import Foundation

class ViewController: BaseViewController {
    
    @IBOutlet weak var appVersionLabel: UILabel!
    
    let appVersion = AppManager.shared.actualAppVersion
    var versionForUpdate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DeviceManager.getFirstLang() == nil, let lang = Locale.current.languageCode {
            setLang(lang: lang)
        } else if let lang = Locale.current.languageCode, lang != DeviceManager.getThemeLang().rawValue {
            setLang(lang: lang)
        }
        appVersionLabel.text = appVersion
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func setLang(lang: String){
        DeviceManager.storeLang(lang: lang)
        DeviceManager.storeThemeLang(lang: lang)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activeCheck(className: "ViewContoller - view did appear", numberLine: 41)
        showLoader()
        self.checkForUpdate(){
            self.activeCheck(className: "ViewContoller - ritrieve product", numberLine: 44)
            AppManager.shared.retrieveProduct(){ withProducts in
                self.activeCheck(className: "ViewContoller - ritrieve product", numberLine: 46)
                if !AppManager.showTutorial {
                    self.activeCheck(className: "ViewContoller - showTutorial", numberLine: 48)
                    AppManager.setShowTutorial()
                    self.hideLoader()
                    
                    
//                    if #available(iOS 15.0, *) {
//                        let height = UIScreen.main.bounds.height
//                        if height > 700 && DeviceManager.currentDevice == .phone {
//                            TutorialSplitContainerViewController.present(presenter: self)
//                        } else {
//                            OnBoardingViewController.present(presenter: self)
//                        }
//                    } else {
//                        OnBoardingViewController.present(presenter: self)
//                    }
                    OnBoardingViewController.present(presenter: self)
                    
                } else {
                    self.activeCheck(className: "ViewContoller - autologin", numberLine: 66)
                    SplashService.autologin(){ isLogged in
                        self.activeCheck(className: "ViewContoller - whatnews", numberLine: 68)
                        SplashService.getWhatNews() { news in
                            self.activeCheck(className: "ViewContoller - getNews", numberLine: 70)
                            if news.count > 0 {
                                var vcs = OnBoardingDataSource.getControllers(items: news)
                                OnBoardingViewController.present(presenter: self, controllers: vcs) {
                                    AppManager.whatNewsVersion = self.appVersion
                                    self.actionAfterLogin(isLogged: isLogged)
                                }
                            } else {
                                self.actionAfterLogin(isLogged: isLogged)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func actionAfterLogin(isLogged : Bool){
        activeCheck(className: "ViewContoller - actionAfterLogin", numberLine: 89)
        hideLoader()
        if isLogged{
            goHome(fromLogin: true)
        } else {
            goToLogin()
        }
    }
    
    func checkForUpdate(completion: @escaping (()->Void)){
        SplashService.getAppConfig(){ [weak self] home in
            
            guard let home = home else {
                self?.hideLoader()
                if AppManager.shared.offlineMode {
                    self?.goHome(fromLogin: true)
                } else {
                    self?.showAlert(alertTypology: .genericError)
                }
                return
            }
            
            AppManager.shared.homeData = home
            self?.versionForUpdate = home.iosConfig?.versionForRequireUpdate
            if self?.updateRequired == true {
                UpdateViewController.present(from: self)
            } else {
                self?.inReview(with: home.iosConfig?.lastAppVersion)
                completion()
            }
        }
    }
    
    override func firstButtonAction(_ type: AlertViewTypology?) {
        super.firstButtonAction(type)
        
        if type == .genericError {
            viewDidAppear(true)
        }
        
        
    }
    
    func inReview(with lastAppVersion: String?){
        if let version = lastAppVersion, version != "" {
            AppManager.shared.inReview = false
            if appVersion.compare(version, options: .numeric) == .orderedDescending {
                AppManager.shared.inReview = true
            }
        }
    }
    
    
    var updateRequired : Bool {
        if let version = versionForUpdate, version != "" {
            return appVersion.compare(version, options: .numeric) == .orderedAscending
        }
        return false
    }
    
    
    func animateBall(ball: UIView, damping: CGFloat, velocity: CGFloat, completion : (() -> Void)? = nil){
        UIView.animate(withDuration: 2.2, delay: 0, usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity, options: [], animations: {
            ball.transform = CGAffineTransform.identity
        },completion: { _ in
            completion?()
        })
    }
    
    
}

