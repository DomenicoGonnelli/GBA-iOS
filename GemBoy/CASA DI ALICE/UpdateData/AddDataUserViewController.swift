//
//  GiveNameViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 15/01/23.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class AddDataUserViewController: BaseViewController, UITextFieldDelegate {
    
    static let identifier = "AddDataUserViewController"
    
    @IBOutlet weak var selectNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nameView: UIView!

    @IBOutlet weak var viewTitle: UILabel!
    
    @IBOutlet weak var viewSubTitle: UILabel!
    
    

    var config : UserDataSteps = .nickName

    
    override func viewDidLoad() {
        enableBack = config != .nickName
        super.viewDidLoad()
        resetView()
        addToolbar(textView: selectNameTextField)
        switch config {
        case .nickName:
            selectNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            selectNameTextField.delegate = self
            selectNameTextField.placeholder = "Nickname"
            selectNameTextField.title = "Nickname"
            selectNameTextField.selectedTitle = "Nickname"
            continueButton.enable(false)
            
            nameView.isHidden = false
        case .energy:
            selectNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            selectNameTextField.delegate = self
            continueButton.enable(false)
            selectNameTextField.keyboardType = .numberPad
            selectNameTextField.placeholder = "Il mio livello di energia [1-10]"
            selectNameTextField.title = "Il mio livello di energia [1-10]"
            selectNameTextField.selectedTitle = "Il mio livello di energia [1-10]"
            
            nameView.isHidden = false
        case .weight:
            selectNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            selectNameTextField.delegate = self
            continueButton.enable(false)
            selectNameTextField.placeholder = "Il mio peso"
            selectNameTextField.title = "Il mio peso"
            selectNameTextField.selectedTitle = "Il mio peso"
           
            nameView.isHidden = false
        case .fianchi:
            selectNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            selectNameTextField.delegate = self
            continueButton.enable(false)
            selectNameTextField.placeholder = "Circonferenza Fianchi"
            selectNameTextField.title = "Circonferenza Fianchi"
            selectNameTextField.selectedTitle = "Circonferenza Fianchi"
            
            nameView.isHidden = false
        case .vita:
            selectNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            selectNameTextField.delegate = self
            continueButton.enable(false)
            selectNameTextField.placeholder = "Circonferenza Vita"
            selectNameTextField.title = "Circonferenza Vita"
            selectNameTextField.selectedTitle = "Circonferenza Vita"
            
            nameView.isHidden = false
        case .altro:
            selectNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            selectNameTextField.delegate = self
            continueButton.enable(false)
            selectNameTextField.placeholder = "Altre info"
            selectNameTextField.title = "Altre info"
            selectNameTextField.selectedTitle = "Altre info"
            
            skipButton.isHidden = true
            nameView.isHidden = false
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func resetView() {
        nameView.isHidden = true
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if(text.removeSpace().count < 2 ) {
                    floatingLabelTextField.errorMessage = "AtLeast2char".localizable
                    continueButton.enable(false)
                } else {
                    floatingLabelTextField.errorMessage = ""
                    continueButton.enable(true)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    @IBAction func continueButton(_ sender: Any){
        
         
    }
    
    
    
    @IBAction func skipButton(_ sender: Any){
        switch config {
        case .nickName:
            
            AddDataUserViewController.push(prensenter: self, config: .energy)
            
        case .energy:
            
            AddDataUserViewController.push(prensenter: self, config: .weight)
            
        case .weight:
            
            AddDataUserViewController.push(prensenter: self, config: .fianchi)
            
        case .fianchi:
            
            AddDataUserViewController.push(prensenter: self, config: .vita)
            
        case .vita:
            
            AddDataUserViewController.push(prensenter: self, config: .altro)
        case .altro:
            if let name = self.selectNameTextField.text{
                
            }
        }
    }
    
    static func instance() -> AddDataUserViewController{
        let vc = UIStoryboard(name: "AddDataUser", bundle: nil).instantiateViewController(withIdentifier: identifier) as! AddDataUserViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func push(prensenter: UIViewController?, config: UserDataSteps) {
        let vc = instance()
        vc.config = config
        prensenter?.navigationController?.pushViewController(vc, animated: true)
    }
    
}



enum UserDataSteps {
    case nickName, energy, weight, fianchi, vita, altro
}
