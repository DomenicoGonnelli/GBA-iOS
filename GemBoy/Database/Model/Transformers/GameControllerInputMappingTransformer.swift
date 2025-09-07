//
//  GameControllerInputMappingTransformer.swift
//  Delta
//
//  Created by Darlion on 9/27/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

import Foundation

import GameCore

@objc(GameControllerInputMappingTransformer)
class GameControllerInputMappingTransformer: ValueTransformer
{
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any?
    {
        guard let inputMapping = value as? GameCore.GameControllerInputMapping else { return nil }
        
        let plistEncoder = PropertyListEncoder()
        
        do
        {
            let data = try plistEncoder.encode(inputMapping)
            return data
        }
        catch
        {
            print(error)
            
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any?
    {
        guard let inputMappingData = value as? Data else { return nil }
        
        let plistDecoder = PropertyListDecoder()
        
        do
        {
            let inputMapping = try plistDecoder.decode(GameCore.GameControllerInputMapping.self, from: inputMappingData)
            return inputMapping
        }
        catch
        {
            print(error)
            
            return nil
        }
    }
}
