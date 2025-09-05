//
//  Parser.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 04/09/2019.
//  Copyright © 2019 Domenico Gonnelli. All rights reserved.
//

import Foundation
import Firebase

class Parser{
    
    class func getAnimalsList(snapshot: QuerySnapshot?) -> [AnimalModel]{
        guard let snapshot = snapshot else { return [] }
        var list : [AnimalModel] = []
        for child in snapshot.documents {
            let value = child.data()
            let animal = AnimalModel(value: value)
            list.append(animal)
            if !SoundManager.instance.checkExistingAudio(audioPath: animal.urlSound) {
                let url = "animalSound/\(animal.urlSound)"
                StorageHelper.getUrlSound(url){url in
                    SoundManager.instance.saveSoundFile(url: url)
                }
            }
        }
        return list
    }
}
