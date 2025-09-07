//
//  GameCollection.swift
//  Delta
//
//  Created by Darlion on 11/1/15.
//  Copyright © 2015 Riley Testut. All rights reserved.
//

import CoreData

import GameCore

@objc(GameCollection)
public class GameCollection: _GameCollection
{
    @objc var name: String {
        return self.system?.localizableName ?? "Unknown".localizable
    }
    
    @objc var shortName: String {
        return self.system?.localizableShortName ?? "Unknown".localizable
    }
    
    var system: System? {
        let gameType = GameType(rawValue: self.identifier)
        
        let system = System(gameType: gameType)
        return system
    }
}
