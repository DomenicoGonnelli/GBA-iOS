//
//  ColorPaletteCell.swift
//  Project
//
//  Created by Domenico Gonnelli on 26/02/25.
//

import Foundation

import UIKit

class ColorPaletteCell: UITableViewCell {
    
    static var identifier = "ColorPaletteCell"
    
    
    @IBOutlet weak var paletteName: UILabel!
    @IBOutlet weak var accentColor: UIView!
    @IBOutlet weak var primaryColor: UIView!
    @IBOutlet weak var invertedPrimaryColor: UIView!
    @IBOutlet weak var lightGrayPrimaryColor: UIView!
    @IBOutlet weak var lightGrayPrimaryColorDark: UIView!
    @IBOutlet weak var purple: UIView!
    @IBOutlet weak var secondaryColor: UIView!
    @IBOutlet weak var backGroundView: DynamicView!
    
    
    func setData(item: language){
        
        let selectedTheme = DeviceManager.getThemeLang()
        
        backGroundView.borderColor = .clear
        backGroundView.borderWidth = 0
        
        if item == selectedTheme {
            backGroundView.borderColor = .secondaryColor
            backGroundView.borderWidth = 2
        }
        
        
        paletteName.localizedKey = item.paletteName
        
    
        accentColor.backgroundColor = getLocalizedUIColor(named: "orangeColor", lang: item.rawValue)
        primaryColor.backgroundColor = getLocalizedUIColor(named: "primaryColorFix", lang: item.rawValue)
        invertedPrimaryColor.backgroundColor = getLocalizedUIColor(named: "buttonTextColor", lang: item.rawValue)
        lightGrayPrimaryColor.backgroundColor = getLocalizedUIColor(named: "primaryColorLight", lang: item.rawValue)
        lightGrayPrimaryColor.overrideUserInterfaceStyle = .light
        lightGrayPrimaryColorDark.backgroundColor = getLocalizedUIColor(named: "primaryColorLight", lang: item.rawValue)
        lightGrayPrimaryColorDark.overrideUserInterfaceStyle = .dark
        purple.backgroundColor = getLocalizedUIColor(named: "purple", lang: item.rawValue)
        secondaryColor.backgroundColor = getLocalizedUIColor(named: "secondaryColor", lang: item.rawValue)
        
    }
    
    
    func getLocalizedUIColor(named colorName: String, lang: String) -> UIColor? {
        return UIColor(named: "\(colorName)-\(lang)") ?? UIColor(named: colorName)
    }
    
}
