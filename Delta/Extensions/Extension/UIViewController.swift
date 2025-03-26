//
//  UIViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import UIKit
import LocalAuthentication

extension UIViewController {
    
    /*! @fn showTextInputPromptWithMessage
     @brief Shows a prompt with a text field and 'OK'/'Cancel' buttons.
     @param message The message to display.
     @param completion A block to call when the user taps 'OK' or 'Cancel'.
     */
    func showTextInputPrompt(withMessage message: String,
                             completionBlock: @escaping ((Bool, String?) -> Void)) {
        let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel".localizable, style: .cancel) { _ in
            completionBlock(false, nil)
        }
        weak var weakPrompt = prompt
        let okAction = UIAlertAction(title: "ok".localizable, style: .default) { _ in
            guard let text = weakPrompt?.textFields?.first?.text else { return }
            completionBlock(true, text)
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(cancelAction)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    
    func goToLogin(){
//        LoginViewController.push(from: self)
//        if var controllers = navigationController?.viewControllers{
//            controllers.removeAll(where: {!($0 is LoginViewController)})
//            self.navigationController?.viewControllers = controllers
//        }
    }
    
//    func getFaceID(force: Bool = false, completion: @escaping (_ isSuccess: Bool, _ isAvailable: Bool) -> ()) {
//        
//        if !force && !LoginManager.isFaceIDEnabled  {
//            completion(true, true)
//            return
//        }
//        
//        let context = LAContext()
//        var error: NSError?
//
//        // Verifichiamo se Face ID è disponibile
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "Autenticati per accedere all'app"
//            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
//                DispatchQueue.main.async {
//                    completion(success, true)
//                }
//            }
//        } else {
//            completion(false, false)
//        }
//    }
    
//    func goHome(fromLogin: Bool = false){
//        if fromLogin {
//            getFaceID() { success, available in
//                if let vc = self as? BaseViewController {
//                    if success {
//                        TabBarViewController.push(from: self)
//                        if var controllers = self.navigationController?.viewControllers{
//                            controllers.removeAll(where: {!($0 is TabBarViewController)})
//                            self.navigationController?.viewControllers = controllers
//                        }
//                    }
//                    if !success && available {
//                        vc.showAlert(alertTypology: .retryFaceID)
//                    }
//                    
//                    if !success && !available{
//                        vc.showAlert(alertTypology: .faceIdUnavailable)
//                    }
//                }
//            }
//        }
//    }
//    
//    func showAlerOk(title: String, message: String, onOk: (() -> Void)? = nil){
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "ok".localizable, style: .default, handler: { action in
//            DispatchQueue.main.async {
//                alertController.dismiss(animated: true, completion: nil)
//                onOk?()
//            }
//        })
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true)
//    }
//    
//    func showAlerCustomCancel(title: String, message: String, firtButtonText: String, onTap: (() -> Void)? = nil){
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: firtButtonText, style: .destructive, handler: { action in
//            DispatchQueue.main.async {
//                alertController.dismiss(animated: true, completion: nil)
//                onTap?()
//            }
//        })
//        alertController.addAction(okAction)
//        let cancelAction = UIAlertAction(title: "cancel".localizable, style: .cancel, handler: { action in
//            DispatchQueue.main.async {
//                alertController.dismiss(animated: true, completion: nil)
//            }
//        })
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true)
//    }
//    
//    
//    func sharingImage(position: Int) -> UIImage?{
//        let hashtagView = InstragramStoryView(frame: CGRect(x: 0, y: 0, width: 1080, height: 1930))
//        hashtagView.setView(position: position)
//        return hashtagView.createImage()
//    }
//    
////    func teamImage(team: TeamModel?, position: Int) -> UIImage?{
////        let hashtagView = InstragramStoryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
////        hashtagView.setView(position: position,team: team)
////        hashtagView.setForTeam()
////        return hashtagView.createImage()
////    }
//    
//    func exportJson(fileName: String = "allTeam"){
//        guard let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: DeviceManager.group)?.appendingPathComponent("\(fileName).json") else {
//            return
//        }
//        
//        let shareViewController: UIActivityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
//        
//        shareViewController.popoverPresentationController?.sourceView = self.view
//        shareViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
//        shareViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//        self.present(shareViewController, animated: true)
//        
//    }
}
