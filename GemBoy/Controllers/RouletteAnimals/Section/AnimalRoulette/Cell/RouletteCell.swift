//
//  RouletteCell.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 03/09/2019.
//  Copyright © 2019 Domenico Gonnelli. All rights reserved.
//

import Foundation
import UIKit

class RouletteCell : UICollectionViewCell {
    
    static var identifier = "RouletteCell"
    
    var angle = CGFloat(0)
    var animal : AnimalModel?
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var testo: UILabel!
    @IBOutlet weak var animalImage: UIImageView!
    
    
    func config (_ animal: AnimalModel, index: Int, _ angle: CGFloat){
        self.animal = animal
        animalImage.setAnimalImage(forName: animal, isTransparent: true)
    
        if angle >= CGFloat.pi {
            self.angle = 2*CGFloat.pi - angle
        } else {
            self.angle = -angle
        }
        
        //let bounds = self.layer.bounds
        //self.view.layer.cornerRadius = bounds.width/2
        //animalImage.layer.cornerRadius = (animalImage.bounds).height/2.2
        //self.view.layer.borderWidth = 0.15
        animalImage.transform = animalImage.transform.rotated(by: CGFloat.pi/2 - self.angle)
        
    }
    
    func updateAngle(theta: CGFloat){
        angle -= theta
        angle = angle.remainder(dividingBy: 2*CGFloat.pi)
    }
}
