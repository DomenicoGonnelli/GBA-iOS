//
//  Dictionary.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//


import Foundation
import UIKit

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = self.data else {
            return nil
        }
        return String(data: theJSONData, encoding: .utf8)
    }
    
    var data : Data?{
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
    
    
    func saveInJson(fileName: String){
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: DeviceManager.group)?.appendingPathComponent("\(fileName).json")
        if let fileURL = fileURL {
            do {
                try JSONSerialization.data(withJSONObject: self).write(to: fileURL)
            } catch {
                print(error)
            }
        }
    }
    
    static func readJson(_ key: String) -> Dictionary<String,Any>?{
        do {
            guard let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: DeviceManager.group)?.appendingPathComponent("\(key).json") else {
                return nil
            }
            let data = try Data(contentsOf: fileURL)
            if let dictionary = try JSONSerialization.jsonObject(with: data) as? Dictionary<String,Any>{
                return dictionary
            }
        } catch {
            print(error)
            return nil
        }
        return nil
    }
    
}
