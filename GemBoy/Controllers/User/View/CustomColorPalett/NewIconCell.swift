//
//  ColorPaletteCell.swift
//  Project
//
//  Created by Domenico Gonnelli on 26/02/25.
//

import Foundation

import UIKit

class NewIconCell: UITableViewCell {
    
    static var identifier = "NewIconCell"
    
    
    @IBOutlet var icons: [UIButton]!
    
    var delegate : ChangeAppIconDelegate?
    
    func setData(){
        for i in 0..<icons.count {
            icons[i].radius = 10
            icons[i].clipsToBounds = true
            icons[i].setBackgroundImage(getAppIcon(index: i), for: .normal)
        }
        
    }
    
  
    func getAppIcon(index: Int) -> UIImage? {
        guard let iconsDict = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = iconsDict["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let alternartive = iconsDict["CFBundleAlternateIcons"] as? [String: Any],
              let lastIcon = iconFiles.first else {
            return nil
        }

            if let icon = alternartive["AppIcon \(index)"] as? [String: Any],
               let names = icon["CFBundleIconFiles"] as? [String],
               let iconName = names.first {
                print("Trying to load icon: \(iconName)")

                // Prova con diverse varianti del nome dell'icona
                if let image = UIImage(named: iconName) {
                    return image
                } else if let image = UIImage(named: "\(iconName)-60") {
                    return image
                } else if let image = UIImage(named: "\(iconName)-60@2x") {
                    return image
                } else if let image = UIImage(named: "\(iconName)-60@3x") {
                    return image
                }
            }
        
        return UIImage(named: lastIcon)
    }
    
    @IBAction func selectedIcon(_ sender: UIButton){
        if let index = icons.firstIndex(of: sender) {
            if index == 0 {
                delegate?.changeAppIcon(to: nil)
            } else {
                delegate?.changeAppIcon(to: "AppIcon \(index)")
            }
        }
    }
    
    
    
}

protocol ChangeAppIconDelegate {
    func changeAppIcon(to iconName: String?)
}
