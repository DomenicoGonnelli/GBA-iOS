//
//  AnimalModel.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 03/09/2019.
//  Copyright © 2019 Domenico Gonnelli. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class AnimalModel : DatabaseModelProtocol{
    
    var name : String
    var urlSound : String
    var urlCartoon : String
    var description : String
    var url : String
    var update : Bool = false
    var verso : String
    var urlCartoonTr : String
    
    init(name: String, description: String, urlSound: String, url: String, update: Bool,urlCartoon: String, verso: String, urlCartoonTr: String){
        self.name = name
        self.description = description
        self.urlSound = urlSound
        self.urlCartoon = urlCartoon
        self.url = url
        self.update = update
        self.verso = verso
        self.urlCartoonTr = urlCartoonTr
    }
    
    required init(value: [String : Any]) {
        self.name = value["name"] as? String ?? ""
        self.description = value["description"]  as? String ?? ""
        self.urlSound = value["urlSuono"] as? String ?? ""
        self.urlCartoon = value["urlCartoon"]  as? String ?? ""
        self.urlCartoonTr = value["urlCartoonTr"]  as? String ?? ""
        self.url = value["url"] as? String ?? ""
        self.update = value["update"] as? Bool ?? false
        self.verso = value["verso"] as? String ?? ""
    }
    
    
    var datafile : Dictionary<String, Any>{
        return [
            "name" : name,
            "description" : description,
            "urlCartoon" : urlCartoon,
            "urlCartoonTr" : urlCartoonTr,
            "urlSuono" : urlSound,
            "url" : url,
            "update" : update,
            "verso" : verso
        ]
    }
    
    func equalTo(_ animal: AnimalModel)->Bool{
        return self.name == animal.name && self.description == animal.description
    }
}

    
