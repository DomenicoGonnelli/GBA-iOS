//
//  StringExtensionCommon.swift
//  Project
//
//  Created by Domenico Gonnelli on 12/03/25.
//

import Foundation


protocol Localizable {
    var localizable: String{get}
}

extension String: Localizable {
    var localizable: String {
        let lang = DeviceManager.getLang().rawValue
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"), let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
    
}
