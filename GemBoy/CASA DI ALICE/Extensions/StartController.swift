//
//  StartController.swift
//  GemBoy
//
//  Created by Domenico Gonnelli on 22/09/25.
//

extension ViewController {
    
    
    func goHomePage(){
        TabBarViewController.push(from: self)
        if var controllers = self.navigationController?.viewControllers{
            controllers.removeAll(where: {!($0 is TabBarViewController)})
            self.navigationController?.viewControllers = controllers
        }
    }
    
}
