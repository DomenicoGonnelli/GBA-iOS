//
//  UpdateViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//

import Foundation
import UIKit
import Lottie

class UpdateViewController: UIViewController {
    
    @IBOutlet weak var animationView: LottieAnimationView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    let animationName = "efupdate"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seAnimation()
        updateButton.setTitle("update_button".localizable, for: .normal)
    }
    
    private func seAnimation(){
        let animation = LottieAnimation.named(animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animation = animation
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = 1
        animationView.play()
    }
    
    @IBAction func updateAction(_ sender: Any) {
        let store = AppManager.shared.homeData?.iosConfig?.appStoreURL ?? "itms-apps://apple.com/app/id1671742077"
        if let url = URL(string: store) {
            UIApplication.shared.open(url)
        }
    }
    
    static func present(from presenter : UIViewController?){
        let viewController = UIStoryboard(name: "Update", bundle: nil).instantiateViewController(withIdentifier: "UpdateViewController") as! UpdateViewController
        viewController.modalPresentationStyle = .overFullScreen
        presenter?.present(viewController, animated: true, completion: nil)
    }
}
