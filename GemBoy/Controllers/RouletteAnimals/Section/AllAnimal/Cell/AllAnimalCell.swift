//
//  AllAnimalCell.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 03/07/2020.
//  Copyright © 2020 Domenico Gonnelli. All rights reserved.
//

import Foundation
import UIKit

class AllAnimalCell : UICollectionViewCell{
    
    @IBOutlet weak var animalImage : UIImageView!
    @IBOutlet weak var animalImageHeight : NSLayoutConstraint!
    
    var animal : AnimalModel? {
        didSet{
            if let animal = animal{
                animalImage.setAnimalImage(forName: animal, isTransparent: false)
                animalImage.addShadow()
            }
        }
    }
    
    func setSize(size: CGFloat){
        animalImageHeight.constant = size 
    }
    
}
 
