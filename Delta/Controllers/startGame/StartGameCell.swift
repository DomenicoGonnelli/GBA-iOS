//
//  StartGameCell.swift
//  Delta
//
//  Created by Domenico Gonnelli on 23/04/25.

import Foundation

import UIKit

class StartGameCell: UITableViewCell{
    
    static var indetifier = "StartGameCell"
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var gameImg : UIImageView!
    
    func configureView(title: String, img: UIImage? ){
        titleLabel.text = title
        gameImg.image = img
        
    }
    
}

