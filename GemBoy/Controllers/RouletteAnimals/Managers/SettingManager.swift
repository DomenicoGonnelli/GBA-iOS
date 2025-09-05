//
//  SettingManager.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 12/09/2019.
//  Copyright © 2019 Domenico Gonnelli. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class SettingManager{
    
    public static var rouletteTutorial : Bool{
        get{ return UserDefaults.standard.bool(forKey: "rouletteTutorial")}
        set(value){
            UserDefaults.standard.set(value, forKey: "rouletteTutorial")
        }
    }

    public static var segmentAnimalRouletteCount : Int{
        get {
            return UserDefaults.standard.integer(forKey: "numberOfAnimal_key")
        }
        set(number) {
            UserDefaults.standard.set(number, forKey: "numberOfAnimal_key")
        }
    }
    
    public static var numberOfAnimalForRoulette : Int {
        
        get {
           return 12 //- 2*self.segmentAnimalRouletteCount
        }
    }
    
    public static var cellDimensionFactor : Double {
        get {
            let count =  self.numberOfAnimalForRoulette
            if count == 12 {
                return 2.48
            } else if count == 10{
                return 2.36
            }
            return 2.21
        }
    }
    
    public static var internalRoulettMultiplier : CGFloat {
        get {
            let count =  self.numberOfAnimalForRoulette
            if count == 12 {
                return 0.58
            } else if count == 10{
                return 0.53
            }
            return 0.447
        }
    }
    
    public static var selectionRoulettMultiplier : CGFloat {
        get {
            let count =  self.numberOfAnimalForRoulette
            if count == 12 {
                return 0.33
            } else if count == 10{
                return 0.355
            }
            return 0.4
        }
    }
    
    
    public static var sound : Float {
        
        get {
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setActive(true)
                return audioSession.outputVolume
            } catch {
                print("Error Setting Up Audio Session")
            }
            return 0.0
        }
        set(value){
            let player = AVPlayer()
            player.volume = value
        }
    }
    
    
    public static var imageMode : String {
        
        get{ return UserDefaults.standard.string(forKey: "imageMode") ?? "cartoon"}
        set(value) {
            UserDefaults.standard.set(value, forKey: "imageMode")
        }
    }
    
    public static var isCartoon : Bool{
         get{ return imageMode == "cartoon"}
    }
    
    
    
}
