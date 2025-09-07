//
//  UIAlertController+Error.swift
//  INLINE
//
//  Created by Darlion on 11/27/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

import Foundation
import Roxas

extension UIAlertController
{
    convenience init(title: String, error: Error?)
    {
        let message: String? = error?.localizedDescription

        
        self.init(title: title, message: message, preferredStyle: .alert)
        
        self.addAction(.ok)
    }
}
