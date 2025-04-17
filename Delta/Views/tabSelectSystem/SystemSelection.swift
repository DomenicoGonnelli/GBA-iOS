//
//  SystemSelection.swift
//  Delta
//
//  Created by Domenico Gonnelli on 17/04/25.
//

import UIKit

class SystemSelection: BaseView{
    
    
    override var nibName: String?{
        return "SystemSelection"
    }
    
    
    @IBOutlet weak var bottomImage: UIImageView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var systemLabel: UILabel!
    
    var delegate: SystemSelectionDelegate?
    var system: System?
    
    func setSystem(system: System?, delegate: SystemSelectionDelegate?){
        self.system = system
        self.delegate = delegate
        bottomImage.image = system?.imageBG
        topImage.image = system?.imageLine
        systemLabel.text = system?.localizableShortName
    }
    
    func selectSystem(color: UIColor?){
        bottomImage.setImageColor(color: color)
    }
    
    @IBAction func pressed(_ sender: Any){
        delegate?.setSystem(system: system)
    }
}


protocol SystemSelectionDelegate{
    func setSystem(system: System?)
}
