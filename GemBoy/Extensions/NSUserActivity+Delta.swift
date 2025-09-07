//
//  NSUserActivity+Delta.swift
//  Delta
//
//  Created by Darlion on 5/9/24.
//  Copyright © 2024 Riley Testut. All rights reserved.
//

import Foundation

extension NSUserActivity
{
    static let playGameActivityType = "com.rileytestut.Delta.PlayGame"
    
    static let gameIDKey = "gameID"
    static let systemIDKey = "systemID"
    static let isSaveStateAvailable = "isSaveStateAvailable"
    
    convenience init(game: Game)
    {
        self.init(activityType: NSUserActivity.playGameActivityType)
        
        self.title = game.name
        self.requiredUserInfoKeys = [NSUserActivity.gameIDKey, NSUserActivity.systemIDKey]
        self.userInfo = [
            NSUserActivity.gameIDKey: game.identifier,
            NSUserActivity.systemIDKey: game.type.rawValue,
        ]
    }
}
