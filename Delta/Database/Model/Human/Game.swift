//
//  Game.swift
//  Delta
//
//  Created by Riley Testut on 10/3/15.
//  Copyright © 2015 Riley Testut. All rights reserved.
//

import Foundation

import DeltaCore
import MelonDSDeltaCore

public extension Game
{
    typealias Setting = __GameSetting
    
    static let melonDSBIOSIdentifier = "com.rileytestut.MelonDSDeltaCore.BIOS"
    static let melonDSDSiBIOSIdentifier = "com.rileytestut.MelonDSDeltaCore.DSiBIOS"
}

@objc(Game)
public class Game: _Game, GameProtocol
{
    public var fileURL: URL {
        var fileURL: URL!
        
        self.managedObjectContext?.performAndWait {
            fileURL = DatabaseManager.gamesDirectoryURL.appendingPathComponent(self.filename)
        }
        
        return fileURL
    }
    
    public override var artworkURL: URL? {
        get {
            self.willAccessValue(forKey: #keyPath(Game.artworkURL))
            var artworkURL = self.primitiveValue(forKey: #keyPath(Game.artworkURL)) as? URL
            self.didAccessValue(forKey: #keyPath(Game.artworkURL))
            
            if let unwrappedArtworkURL = artworkURL
            {
                if unwrappedArtworkURL.isFileURL
                {
                    // Recreate the stored URL relative to current sandbox location.
                    artworkURL = URL(fileURLWithPath: unwrappedArtworkURL.relativePath, relativeTo: DatabaseManager.gamesDirectoryURL)
                }
                else if let host = unwrappedArtworkURL.host?.lowercased(), host == "img.gamefaqs.net" || host == "gamefaqs1.cbsistatic.com",
                        var components = URLComponents(url: unwrappedArtworkURL, resolvingAgainstBaseURL: false)
                {
                    // Quick fix for broken album artwork URLs due to host change.
                    components.host = "gamefaqs.gamespot.com"
                    components.scheme = "https"
                    
                    let updatedPath = "/a" + components.path
                    components.path = updatedPath
                    
                    if let url = components.url
                    {
                        artworkURL = url
                    }
                }
            }
            
            return artworkURL
        }
        set {
            self.willChangeValue(forKey: #keyPath(Game.artworkURL))
            
            var artworkURL = newValue
            
            if let newValue = newValue, newValue.isFileURL
            {
                // Store a relative URL, since the sandbox location changes.
                artworkURL = URL(fileURLWithPath: newValue.lastPathComponent, relativeTo: DatabaseManager.gamesDirectoryURL)
            }
            
            self.setPrimitiveValue(artworkURL, forKey: #keyPath(Game.artworkURL))
            
            self.didChangeValue(forKey: #keyPath(Game.artworkURL))
        }
    }
    
    var settings: [Setting: Any] {
        get {
            guard let gameSettings = self.gameSettings as? [String: Any] else { return [:] }
            
            let settings = gameSettings.map { (Setting(rawValue: $0), $1) }.reduce(into: [:]) { $0[$1.0] = $1.1 }
            return settings
        }
        set {
            if newValue.isEmpty
            {
                self.gameSettings = nil
            }
            else
            {
                self.gameSettings = newValue as NSDictionary
            }
        }
    }
}

extension Game
{
    class var recentlyPlayedFetchRequest: NSFetchRequest<Game> {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K != nil", #keyPath(Game.playedDate))
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Game.playedDate, ascending: false), NSSortDescriptor(keyPath: \Game.name, ascending: true)]
        fetchRequest.fetchLimit = 4
        
        return fetchRequest
    }
}

extension Game
{
    override public func prepareForDeletion()
    {
        super.prepareForDeletion()
        
        guard let managedObjectContext = self.managedObjectContext else { return }
                
        // If filename == empty string (e.g. during merge), ignore this deletion.
        // Otherwise, we may accidentally delete the entire Games directory!
        guard !self.filename.isEmpty else { return }
        
        // If a game with the same identifier is also currently being inserted, Core Data is more than likely resolving a conflict by deleting the previous instance
        // In this case, we make sure we DON'T delete the game file + misc other Core Data relationships, or else we'll just lose all that data
        guard !managedObjectContext.insertedObjects.contains(where: { ($0 as? Game)?.identifier == self.identifier }) else { return }
        
        // Double-check fileURL is NOT actually a directory, which we should never delete.
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: self.fileURL.path, isDirectory: &isDirectory), !isDirectory.boolValue else { return }
        
        do
        {
            try FileManager.default.removeItem(at: self.fileURL)
        }
        catch
        {
            print(error)
        }
        
        if let collection = self.gameCollection, collection.games.count == 1
        {
            // Once this game is deleted, collection will have 0 games, so we should delete it
            managedObjectContext.delete(collection)
        }
        
        // Manually cascade deletion since SaveState.fileURL references Game, and so we need to ensure we delete SaveState's before Game
        // Otherwise, we crash when accessing SaveState.game since it is nil
        for saveState in self.saveStates
        {
            managedObjectContext.delete(saveState)
        }
        
        if managedObjectContext.hasChanges
        {
            managedObjectContext.saveWithErrorLogging()
        }
    }
}
