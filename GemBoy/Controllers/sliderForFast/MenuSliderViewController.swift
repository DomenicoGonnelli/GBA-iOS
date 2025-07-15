//
//  MenuSliderViewController.swift
//  GemBoy
//
//  Created by Domenico Gonnelli on 29/06/25.
//


import Foundation
import UIKit

class MenuSliderViewController: BaseViewController {
    
    static let identifier = "MenuSliderViewController"
    
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    var newWindow: UIWindow?

    deinit {
        // Quando il controller viene deallocato, rimuovi anche la finestra
        newWindow = nil
    }
   
    override func viewDidLoad() {
        isToPresent = true
        super.viewDidLoad()
        guard let _ = LoginManager.shared.user else {
            self.showAlert(alertTypology: .genericError)
            return
        }

        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    static func instance() -> MenuSliderViewController{
        let vc = UIStoryboard(name: "MenuSlider", bundle: nil).instantiateViewController(withIdentifier: identifier) as! MenuSliderViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func present(prensenter: UIViewController) {
        let vc = instance()
        prensenter.present(vc, animated: true)
    }
    
    static func presentInNewWindow() {
        let vc = instance()
        
        // Crea una nuova finestra con le dimensioni dello schermo
        var window = UIWindow(frame: UIScreen.main.bounds)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
        }
        window.windowLevel = .alert + 1 // Per assicurarti che sia sopra altre finestre
        window.rootViewController = vc
        
        // Salva il riferimento alla finestra (importante per mantenere la finestra in memoria)
        vc.newWindow = window
        
        // Mostra la finestra
        window.makeKeyAndVisible()
    }
    
    func closeWindow() {
        self.newWindow = nil
    }
    
    static func push(from nav: UIViewController) {
        let vc = instance()
        nav.navigationController?.pushViewController(vc, animated: true)
    }

    
}
