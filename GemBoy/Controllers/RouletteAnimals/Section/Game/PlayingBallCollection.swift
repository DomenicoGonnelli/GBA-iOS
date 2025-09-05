//
//  PlayingBallCollection.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 01/07/2020.
//  Copyright © 2020 Domenico Gonnelli. All rights reserved.
//
import Foundation

struct PlayingBallCollection
{
    private(set) var animals = [AnimalModel]()
    
    init() {
       //Capire cosa fare ????
    }
    
    mutating func draw() -> AnimalModel? {
        if animals.count > 0 {
            return animals.remove(at: animals.count.arc4random)
        } else {
            return nil
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
