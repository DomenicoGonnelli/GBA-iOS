//
//  MenuSliderViewController.swift
//  GemBoy
//
//  Created by Domenico Gonnelli on 29/06/25.
//


import Foundation
import UIKit
import GameCore

class MenuSliderViewController: BaseViewController {
    
    static let identifier = "MenuSliderViewController"
    
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var contentView: UIView!
    
    var controller : PauseViewController?
    var gameProtocol: GameProtocol?
    var currentSpeed: CGFloat = 1
    
    deinit {
        // Quando il controller viene deallocato, rimuovi anche la finestra
        controller?.secondaryWindow = nil
    }
   
    override func viewDidLoad() {
        isToPresent = true
        super.viewDidLoad()
       
        slider.minimumValue = 0.8
        slider.maximumValue = 10
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        if let gameProtocol = gameProtocol{
            currentSpeed = CGFloat(gameProtocol.gameSpeed)
        }
        
        slider.value = Float(currentSpeed)
        sliderValueChanged(slider)
        contentView.transform = CGAffineTransform.init(scaleX: CGFloat(0.01), y: CGFloat(0.01))
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1){
            self.contentView.transform = CGAffineTransform.identity
        }
    }
    
    override func rightAction() {
        view.window?.isHidden = true
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first?
            .makeKeyAndVisible()
        closeWindow()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value * 10) / 10.0
        currentSpeed = CGFloat(roundedValue)
        userInfoLabel.text = String(format: "slider_value_text".localizable, "\(roundedValue)")
    }
    
    static func instance(controller: UIViewController?) -> MenuSliderViewController{
        let vc = UIStoryboard(name: "MenuSlider", bundle: nil).instantiateViewController(withIdentifier: identifier) as! MenuSliderViewController
        vc.modalPresentationStyle = .fullScreen
        vc.controller = controller as? PauseViewController
        return vc
    }
    
    
    func closeWindow() {
        if var gameProtocol = gameProtocol {
            gameProtocol.gameSpeed = Double(currentSpeed)
        }
        controller?.secondaryWindow = nil
    }

    
}
