//
//  AnimalBase.swift
//  GemBoy
//
//  Created by Domenico Gonnelli on 05/09/25.
//

import Foundation
import UIKit
import AVFoundation

class AnimalBaseViewController : BaseViewController, AVAudioPlayerDelegate {
    var avPlayer : AVAudioPlayer?
    var isFirst = true;
    var timer = Double.random(in: 3..<9);
    
    var numberOfAnimals : Int {
        get {
            return SettingManager.numberOfAnimalForRoulette
        }
    }
    
    @IBOutlet weak var baseHeight : NSLayoutConstraint?
}

