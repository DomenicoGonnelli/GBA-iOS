//
//  Data.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation


extension Data {
    
    var jsonString: String?{
        return self.json?.jsonStringRepresentation
    }
    
    var json: Dictionary<String,Any>?{
        return try? JSONSerialization.jsonObject(with: self, options: []) as? Dictionary<String,Any>
    }
}

extension URL{

    func countFilesInURLDirectory() -> Int {
        let fileManager = FileManager.default
            do {
                let files = try fileManager.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [])
                return files.count
            } catch {
                print("Errore nel recuperare i file dalla cartella: \(error)")
                return 0
            }
    }
}
