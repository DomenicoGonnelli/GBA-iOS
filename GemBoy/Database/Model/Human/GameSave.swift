//
//  GameSave.swift
//  Delta
//
//  Created by Riley Testut on 8/30/16.
//  Copyright (c) 2016 Riley Testut. All rights reserved.
//

import Foundation

import GBCDeltaCore

import Roxas

@objc(GameSave)
public class GameSave: _GameSave 
{
    public override func awakeFromInsert()
    {
        super.awakeFromInsert()
        
        self.modifiedDate = Date()
    }
}

