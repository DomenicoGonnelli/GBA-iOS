//
//  LocalGameProtocol.swift
//  Delta
//
//  Created by Domenico Gonnelli on 05/04/25.
//

import Foundation
import GameCore

protocol LocalGameProtocol: GameProtocol {
    
    var localSaveURL: URL {get}
}


extension LocalGameProtocol
{
    var localSaveURL: URL {
        let fileExtension = Delta.core(for: self.type)?.gameSaveFileExtension ?? "sav"
        
        let fileName = self.fileURL.deletingPathExtension().lastPathComponent
        var gameURL = self.fileURL.deletingLastPathComponent()
        if !LoginManager.shared.isAnonymous, let uid = FirestoreHelper.uid{
            gameURL = gameURL.appendingPathComponent(uid)
        }
        gameURL = gameURL.appendingPathComponent(fileName)
        let gameSaveURL = gameURL.appendingPathExtension(fileExtension)
        print(gameSaveURL.absoluteString)
        
        return gameSaveURL
    }
    
    
}
