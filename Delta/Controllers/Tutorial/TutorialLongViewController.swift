//
//  TutorialLongViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//

import Foundation
import UIKit

class TutorialLongViewController: BaseViewController{
    
    static let identifier = "TutorialLongViewController"
    @IBOutlet weak var rulesLabel: UILabel!
    
    override func viewDidLoad() {
        isToPresent = true
        super.viewDidLoad()
        
//        showLoader()
//        if let urlJson = AppManager.shared.rulesLink, let url = URL(string: urlJson) {
//            ServiceHelper.instance.driveServiceHtml(url: url, request: nil, method: .get) { text in
//                self.hideLoader()
//                self.rulesLabel.setAttributedWithTag(text: text?.convertHtmlToAppTag(), boldSize: 18)
//            }
//        } else {
//            self.hideLoader()
//            showAlert(alertTypology: .genericError)
//        }
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    override func rightAction() {
        self.dismiss(animated: true)
    
    }
    
    static func instance() -> TutorialLongViewController{
        var vc = UIStoryboard(name: "TutorialLong", bundle: nil).instantiateViewController(withIdentifier: identifier) as! TutorialLongViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
        
    }
    
    static func push(from controller: UIViewController?){
        controller?.navigationController?.pushViewController(instance(), animated: false)
    }
    
    static func present(from controller: UIViewController?){
        controller?.present(instance(), animated: true)
    }
    
}
