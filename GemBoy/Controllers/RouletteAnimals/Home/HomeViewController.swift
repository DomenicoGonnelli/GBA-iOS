//
//  MainTabBarViewController.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 03/09/2019.
//  Copyright © 2019 Domenico Gonnelli. All rights reserved.
//

import UIKit
import FirebaseAuth
import Lottie

class HomeViewController: AnimalBaseViewController {

    static let identifier = "HomeViewController"
    
    @IBOutlet weak var tableView : UITableView!
    
    let sections : [homeSection] = [.roulette,.question,.list,.other]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoader()
        AnimalManager.shared.setAnimals(){
            self.hideLoader()
        }
        
        
        tableView.rowHeight = view.frame.height/CGFloat(sections.count + 1)
    }
    
    static func instance() -> HomeViewController{
        return UIStoryboard(name: "MainHome", bundle: nil).instantiateViewController(withIdentifier: identifier) as! HomeViewController
    }
    
    static func push(from controller: UIViewController?){
        controller?.navigationController?.pushViewController(instance(), animated: false)
    }
    
}


extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.identifier) as! HomeCell
        cell.section = sections[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HomeCell
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch cell.section {
        case .roulette:
            AnimalRouletteVC.push(presenter: self)
        case .question:
            AnimalGameViewController.push(presenter: self)
        case .puzzle:
            print("not implemented")
        case .none:
            print("not implemented")
        case .some(.list):
            AllAnimalViewController.present(presenter: self)
        case .other:
            UserProfileViewController.push2(prensenter: self, backcontroller: self)
        }
        
    }
    
}
