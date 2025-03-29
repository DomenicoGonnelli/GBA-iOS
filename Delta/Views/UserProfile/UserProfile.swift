//
//  UserProfile.swift
//  Project
//
//  Created by Domenico Gonnelli on 18/01/25.
//

import Foundation

import UIKit

class UserProfile: BaseView{
    
    override var nibName: String?{
        return "UserProfile"
    }
    
    
    @IBOutlet weak var defaultImage: UIImageView!
   
    @IBOutlet weak var casco: UIImageView!
    @IBOutlet weak var car: UIImageView!
    @IBOutlet weak var visiera: UIImageView!
    @IBOutlet weak var bg_view: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureView(user: UserColorModel?){
       
        let isDefault = user  == nil || user?.allAreNull == true
        
        defaultImage.isHidden = !isDefault
        if !isDefault {
            bg_view.backgroundColor = user?.background
            casco.setTintColor = user?.casco
            car.setTintColor = user?.car
            visiera.setTintColor = user?.visiera
        }
        layoutSubviews()
    }
}


class UserColorModel{
    var casco: UIColor?
    var background: UIColor?
    var car: UIColor?
    var visiera: UIColor?
    
    init(random: Bool, defaultColor: UIColor? = nil){
        if random {
            background = UIColor.random
            casco = UIColor.random
            car = UIColor.random
            visiera = UIColor.random
        } else if let defaultColor = defaultColor{
            background = defaultColor
            casco = defaultColor
            car = defaultColor
            visiera = defaultColor
        }
    }
    
    var allAreNull: Bool{
        casco == nil && background == nil && car == nil && visiera == nil
    }
    
    var createList: String {
        let l0 = background?.hexString ?? ""
        let l1 = car?.hexString ?? ""
        let l2 = casco?.hexString ?? ""
        let l3 = visiera?.hexString ?? ""
        return "#\(l0)|#\(l1)|#\(l2)|#\(l3)"
    }
    
    init(colors : String) {
        
        let list = colors.split(separator: "|")
        
        if list.count >= 4 {
            background = list[0] != "#" ? UIColor(String(list[0])) : nil
            car = list[1] != "#" ? UIColor(String(list[1])) : nil
            casco = list[2] != "#" ? UIColor(String(list[2])) : nil
            visiera = list[3] != "#" ? UIColor(String(list[3])) : nil
        }
    }
}
