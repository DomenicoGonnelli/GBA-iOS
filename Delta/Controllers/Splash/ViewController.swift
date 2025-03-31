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
        if let lang = Locale.current.languageCode {
            DeviceManager.storeLang(lang: lang)
        }
        appVersionLabel.text = appVersion
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoader()
        
        AppManager.shared.retrieveProduct(){ withProducts in
            self.checkForUpdate(){
                if !AppManager.showTutorial {
                    AppManager.setShowTutorial()
                    self.hideLoader()
                    
                    
                    if #available(iOS 15.0, *) {
                        let height = UIScreen.main.bounds.height
                        if height > 700 && DeviceManager.currentDevice == .phone {
                            TutorialSplitContainerViewController.present(presenter: self)
                        } else {
                            OnBoardingViewController.present(presenter: self)
                        }
                    } else {
                        OnBoardingViewController.present(presenter: self)
                    }
                    
                } else {
                    SplashService.autologin(){ isLogged in
                        self.hideLoader()
                        if isLogged{
                            self.goHome(fromLogin: true)
                        } else {
                            self.goToLogin()
                        }
                    }
                }
            }
        }
    }
    
    func checkForUpdate(completion: @escaping (()->Void)){
        SplashService.getAppConfig(){ [weak self] home in
            
            guard let home = home else {
                self?.hideLoader()
                self?.showAlert(alertTypology: .genericError)
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

