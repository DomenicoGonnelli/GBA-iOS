//
//  LoginViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//

import Foundation
import UIKit
import Lottie
import Firebase
import GoogleSignIn
import CryptoKit
import AuthenticationServices


class LoginViewController: TabBarItemViewController{
    
    static let identifier = "LoginViewController"
    
    @IBOutlet weak var googleButton: UIView!
    @IBOutlet weak var appleButton: UIView!
    
    fileprivate var currentNonce: String?
    
    var identificator : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginButton()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupLoginButton() {
        let nonce = LoginManager.randomNonceString()
        currentNonce = nonce
        setAppleButton()
    }
    
    func setAppleButton(){
        
        if #available(iOS 13, *) {
            appleButton?.isHidden = false
        } else {
            appleButton?.isHidden = true
        }
        
#if Darlion
        appleButton?.isHidden = true
#endif
        
    }
    
    func appleAuth( idToken: String){
        if let currentNonce = currentNonce {
            LoginService.doAppleLogin(idToken: idToken, nonce: currentNonce){ userLogin in
                if let userLogin = userLogin {
                    self.hideLoader()
                    self.activeCheck(className: "LoginViewController", numberLine: 59)
                    self.goHome(fromLogin: true)
                } else {
                    self.hideLoader()
                    self.showAlert(alertTypology: .loginError)
                }
            }
        }
    }
    
    @IBAction func loginWithApple(_ sender: Any){
        if #available(iOS 13, *) {
            startSignInWithAppleFlow()
        }
    }
    
    @IBAction func loginWithGoogle(_ sender: Any){
        showLoader()
        activeCheck(className: "LoginViewController", numberLine: 76)
        loginWithGoogle()
    }
    
    @IBAction func openTutorial(_ sender: Any){
       // TutorialLongViewController.present(from: self)
    }
   
    
    static func instance() -> LoginViewController{
        return UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: identifier) as! LoginViewController
    }
    
    static func push(from controller: UIViewController?){
        controller?.navigationController?.pushViewController(instance(), animated: false)
    }
    
    override func firstButtonAction(_ type: AlertViewTypology?) {
        self.removeAlert()
    }
    
    override func secondButtonAction(_ type: AlertViewTypology?) {
        self.removeAlert()
    }
}


//MARK: APPLE LOGIN

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = LoginManager.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce, let appleIDToken = appleIDCredential.identityToken else {
                self.hideLoader()
                self.showAlert(alertTypology: .loginError)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                self.hideLoader()
                self.showAlert(alertTypology: .loginError)
                return
            }
            self.showLoader()
            activeCheck(className: "LoginViewController", numberLine: 148)
            self.appleAuth(idToken: idTokenString)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


//MARK: Google Login
extension LoginViewController {
    
    func loginWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, err in
            
            guard
                let authentication = signInResult?.user,
                let idToken = authentication.idToken?.tokenString
            else {
                self.hideLoader()
                self.showAlert(alertTypology: .loginError)
                return
            }
            
            let accessToken = authentication.accessToken.tokenString
            self.identificator = authentication.profile?.email
        
            LoginService.doLogin(idToken: idToken, accessToken: accessToken){ userLogin in
                self.activeCheck(className: "LoginViewController", numberLine: 190)
                self.hideLoader()
                if var userLogin = userLogin {
                   // userLogin.profilePhoto = authentication.profile?.imageURL(withDimension: 150)?.absoluteString
                    self.goHome(fromLogin: true)
                } else {
                    self.showAlert(alertTypology: .loginError)
                }
            }
        }
    }
}
