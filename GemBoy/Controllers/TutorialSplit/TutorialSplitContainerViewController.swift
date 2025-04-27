//
//  TutorialSplitContainerViewController.swift
//  Project
//
//  Created by Domenico Gonnelli on 12/02/24.
//

import Foundation

import Foundation
import UIKit

@available(iOS 15.0, *)
class TutorialSplitContainerViewController : BaseViewController {
    
    static var identifier = "TutorialSplitContainerViewController"
    
    @IBOutlet weak var container: UIView!
    
    var controller: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
        var tutorialView = TutorialSplitView()
        tutorialView.controller = self
        
        let vc = TutorialSplitViewController.makeViewController(tutorialView, statusBarStyle: .default)
        addChild(vc)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(vc.view)
        
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            vc.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        vc.didMove(toParent: self)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    static func instance(controller: UIViewController) -> TutorialSplitContainerViewController{
        let vc = UIStoryboard(name: "TutorialSplit", bundle: nil).instantiateViewController(withIdentifier: identifier) as! TutorialSplitContainerViewController
        vc.controller = controller
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func present(presenter: UIViewController, completion: (() -> Void)? = nil){
        presenter.present(instance(controller: presenter), animated: true, completion: completion)
        
    }
}
