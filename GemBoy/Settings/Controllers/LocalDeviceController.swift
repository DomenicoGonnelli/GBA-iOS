//
//  LocalDeviceController.swift
//  Delta
//
//  Created by Darlion on 1/12/24.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import GameCore

class LocalDeviceController: NSObject, GameController
{
    var name: String {
        if ProcessInfo.processInfo.isRunningOnVisionPro
        {
            return "Touch".localizable
        }
        else
        {
            return "TouchScreen".localizable
        }
    }
    
    var playerIndex: Int? {
        set { Settings.localControllerPlayerIndex = newValue }
        get { return Settings.localControllerPlayerIndex }
    }
    
    let inputType: GameControllerInputType = .standard
    
    var defaultInputMapping: GameControllerInputMappingProtocol?
}
