//
//  StartController.swift
//  GemBoy
//
//  Created by Domenico Gonnelli on 22/09/25.
//

extension ViewController {
    
    
    override func goHomePage(){
        HomeViewController.push(from: self)
        if var controllers = self.navigationController?.viewControllers{
            controllers.removeAll(where: {!($0 is HomeViewController)})
            self.navigationController?.viewControllers = controllers
        }
    }
    
}
