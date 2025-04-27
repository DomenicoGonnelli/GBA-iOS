//
//  ColorPaletteViewController.swift
//  Project
//
//  Created by Domenico Gonnelli on 26/02/25.
//

import Foundation
import UIKit


class ColorPaletteViewController: BaseViewController, ChangeAppIconDelegate {
    
    static let identifier = "ColorPaletteViewController"
    
    @IBOutlet weak var tableView: UIView!
    
    let languages = language.list
    
    var selectedLanguage: language = DeviceManager.getLang()

    override func viewDidLoad() {
        isToPresent = true
        super.viewDidLoad()
       
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func firstButtonAction(_ type: AlertViewTypology?) {
        if type == .newConfiguration {
            setAppLanguage(to: DeviceManager.getThemeLang().rawValue)
            restartApp()
        }
        else {
            super.firstButtonAction(type)
        }
    }
    
    override func secondButtonAction(_ type: AlertViewTypology?) {
        super.secondButtonAction(type)
    }
    
    
    
    func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            showAlert(alertTypology: .genericError)
            return }
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                self.showAlert(alertTypology: .genericError)
            } else {
                print("Icona cambiata con successo!")
            }
        }
        
    }
    
    
    
    static func instance() -> ColorPaletteViewController{
        let vc = UIStoryboard(name: "ColorPalette", bundle: nil).instantiateViewController(withIdentifier: identifier) as! ColorPaletteViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func present(prensenter: BaseViewController) {
        let vc = instance()
        prensenter.present(vc, animated: true)
    }
    
    
}


extension ColorPaletteViewController: UITableViewDataSource, UITableViewDelegate{
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return languages.count
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorPaletteCell.identifier, for: indexPath) as! ColorPaletteCell
            let item = languages[indexPath.row]
            cell.setData(item: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewIconCell.identifier, for: indexPath) as! NewIconCell
            cell.setData()
            cell.delegate = self
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let lang = languages[indexPath.row]
            DeviceManager.storeThemeLang(lang: lang.rawValue)
            showAlert(alertTypology: .newConfiguration)
        }
        
    }
}
