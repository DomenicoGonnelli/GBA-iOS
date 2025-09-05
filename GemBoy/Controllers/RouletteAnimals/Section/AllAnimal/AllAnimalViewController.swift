//
//  AllAnimalViewController.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 03/07/2020.
//  Copyright © 2020 Domenico Gonnelli. All rights reserved.
//

import Foundation
import UIKit

class AllAnimalViewController : AnimalBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    var list : [AnimalModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationBar?.titleText = homeSection.list.title
        
        
        self.list = AnimalManager.shared.animals
        self.collectionView.reloadData()
        if list.count == 0 {
            self.showAlerOk(title: "Error".localizable, message: "get_animals_error".localizable)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllAnimalCell", for: indexPath) as! AllAnimalCell
        cell.animal = list[indexPath.row]
        cell.setSize(size: (view.bounds.width) / CGFloat(Double(3) * 1.1))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        playSound(for: list[indexPath.row])
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let length = (view.bounds.width) / CGFloat(Double(3))
           return CGSize(width: length, height: length)
       }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    public static func present(presenter: UIViewController){
        let controller = UIStoryboard(name: "AllAnimal", bundle: nil).instantiateViewController(withIdentifier: "AllAnimalViewController") as! AllAnimalViewController
        presenter.navigationController?.pushViewController(controller, animated: true)
    }
}
