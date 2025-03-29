//
//  ColorPickerManager.swift
//  Project
//
//  Created by Domenico Gonnelli on 20/01/25.
//

import Foundation
import UIKit


class ColorPickerManager: NSObject, UIColorPickerViewControllerDelegate, UINavigationControllerDelegate {

    var picker = UIColorPickerViewController();
    var viewController: UIViewController?
    var navController: UINavigationController?
    var pickCallback : ((UIColor?) -> ())?
    var previousColor : UIColor?
    
    override init(){
        super.init()
        picker.selectedColor = .white
        picker.supportsAlpha = false
        picker.delegate = self
        picker.modalPresentationStyle = .automatic
    }
    
    @objc func close(){
        self.colorPickerViewControllerDidFinish(picker)
        navController?.dismiss(animated: true)
    }
    
    func pickColor(_ color: UIColor, _ viewController: UIViewController, _ callback: @escaping ((UIColor?) -> ())) {
        picker.selectedColor = color
        previousColor = color
        pickCallback = callback;
        self.viewController = viewController;
        
        navController = UINavigationController(rootViewController: picker)
        picker.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done".localizable, style: .done, target: self, action: #selector(close))
        navController?.view.backgroundColor = .systemBackground
        navController?.modalPresentationStyle = .pageSheet
        
        if let nc = navController {
            viewController.present(nc, animated: true, completion: nil)
        }
    }
    
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        if let previousColor = previousColor, previousColor != viewController.selectedColor {
            pickCallback?(viewController.selectedColor)
        }
    }
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        
    }
    
}
