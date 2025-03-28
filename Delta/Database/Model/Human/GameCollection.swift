//
//  GameCollection.swift
//  Delta
//
//  Created by Riley Testut on 11/1/15.
//  Copyright © 2015 Riley Testut. All rights reserved.
//

import CoreData

import DeltaCore

@objc(GameCollection)
public class GameCollection: _GameCollection
{
    @objc var name: String {
        return self.system?.localizedName ?? NSLocalizedString("Unknown", comment: "")
    }
    
    @objc var shortName: String {
        return self.system?.localizedShortName ?? NSLocalizedString("Unknown", comment: "")
    }
    
    var system: System? {
        let gameType = GameType(rawValue: self.identifier)
        
        let system = System(gameType: gameType)
        return system
    }
}
