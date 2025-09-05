//
//  AnimalManager.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 10/01/2021.
//  Copyright © 2021 Domenico Gonnelli. All rights reserved.
//

import Foundation


class AnimalManager {
    
    private static var _instance : AnimalManager?
    
    public static var shared : AnimalManager{
        get{
            if(_instance == nil){
                _instance = AnimalManager()
            }
            return _instance!
        }
    }
    
    var animals : [AnimalModel] = []
    
    func setAnimals(_ completion: @escaping () -> ()){
        FirestoreHelper.getAnimalsList(){ list in
            self.animals = list
            completion()
        }
    }
    
    func reductedAnimals(with numberOfAnimals : Int) -> [AnimalModel]? {
        if animals.count >= numberOfAnimals {
            let count = animals.count - numberOfAnimals
            var animalForRoulette = animals
            for _ in 0..<count {
                let randomIndex = Int.random(in: 0..<animalForRoulette.count)
                animalForRoulette.remove(at: randomIndex)
            }
            return animalForRoulette
        }
        
        return nil
    }
    
}
