//
//  ImageManager.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 07/09/2019.
//  Copyright © 2019 Domenico Gonnelli. All rights reserved.
//

import Foundation
import UIKit

class ImageManager {
    
    //Animal Image
    public static func storeImage(animal: AnimalModel, image: Data?, isTransparent: Bool){
        let preferences = UserDefaults.standard
        let key = isTransparent ? animal.urlCartoonTr : animal.urlCartoon
        preferences.set(image, forKey: key)
        //  Save to disk
        let didSave = preferences.synchronize()
        if didSave {
            print("stored image for \(key)")
        }
    }
    
     public static func isImageStored(animal: AnimalModel, isTransparent: Bool) -> Bool{
        let preferences = UserDefaults.standard
        let key = isTransparent ? animal.urlCartoonTr : animal.urlCartoon
        if let _ = preferences.object(forKey: key){
            return true
        }
        return false
    }
    
    public static func reloadImage(animal: AnimalModel, isTransparent: Bool) -> UIImage?{
        let preferences = UserDefaults.standard
        let key = isTransparent ? animal.urlCartoonTr : animal.urlCartoon 
        if let data = preferences.object(forKey: key){
            return UIImage(data: data as! Data)
        }
        return nil
    }
}
