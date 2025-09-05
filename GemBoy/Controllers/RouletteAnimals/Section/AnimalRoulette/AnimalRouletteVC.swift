//
//  AnimalRouletteVC.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 03/09/2019.
//  Copyright © 2019 Domenico Gonnelli. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AnimalRouletteVC : AnimalBaseViewController{
   
    @IBOutlet weak var rouletteTutorialLabel: UILabel!
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var rouletteView: UICollectionView!
    @IBOutlet weak var rouletteImage: UIImageView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var selectedAnimal: UIImageView!
    @IBOutlet weak var rouletteCompleteView: UIView!
    @IBOutlet weak var externalRoulette: UIImageView!
    @IBOutlet weak var ruotaTurorial: UIButton!
    @IBOutlet weak var internalButton: UIButton!
    
    //var avPlayer : AVAudioPlayer?
    var animals : [AnimalModel] = []
    
    var angleStep = CGFloat(0)
    var rounded = false
    
    var randomAnimal : AnimalModel?
    
    var centralRouteContraint : NSLayoutConstraint?
    var selectionViewConstraints : NSLayoutConstraint?
    
    var radius : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rouletteCompleteView.isHidden = true
       // self.resizeCentralView()
        self.navigationBar?.titleText = homeSection.roulette.title
        internalButton.setTitle("rotation_button".localizable, for: .normal)
        if !SettingManager.rouletteTutorial{
            showRouletteTutorial(show: true)
        } else {
            tutorialView.isHidden = true
        }
        self.selectedAnimal.alpha = 0.2
        radius = selectedAnimal.frame.height
        if animals.count != numberOfAnimals {
            rechargeAnimalRoulette()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !rounded {
            rounded = true
            rouletteView?.roundLayer()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        setView(isQuestion: false)
        removeAnimal()
    }
    
    func rechargeAnimalRoulette(){
        
        guard let list = AnimalManager.shared.reductedAnimals(with: self.numberOfAnimals) else {
            self.showAlerOk(title: "Error".localizable, message: "get_animals_error".localizable)
            return
        }
        self.animals = list
        rouletteCompleteView.isHidden = false
        self.angleStep = 2*CGFloat.pi/CGFloat(self.animals.count)
        self.rouletteImage.transform = CGAffineTransform.identity
        self.rouletteView.transform = CGAffineTransform.identity
        self.rouletteView.reloadData()
    }
    
    
    
    func resizeCentralView(){
        if let constraint = centralRouteContraint{
            view.removeConstraint(constraint)
        }
        centralRouteContraint = NSLayoutConstraint(item: centerView, attribute: .width, relatedBy: .equal, toItem: rouletteView, attribute: .width, multiplier: SettingManager.internalRoulettMultiplier, constant: 0)
        if let constraint = centralRouteContraint{
            view.addConstraint(constraint)
        }
        centerView.layoutIfNeeded()
    }
    
    
    @IBAction func StartRotation(_ sender: Any) {
        
        if animals.count >= self.numberOfAnimals {
            centerView.isUserInteractionEnabled = false
            if !SettingManager.rouletteTutorial{
                SettingManager.rouletteTutorial = true
                showRouletteTutorial(show: false)
            }
            
            rouletteView.startRotation(duration: 3, numberOfElement: animals.count, otherView: rouletteImage){j in
                if self.animals.count > 0 {
                    self.setAnimal(self.animals[j])
                    self.playSound(for: self.animals[j])
                    self.centerView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.resizeCentralView()
    }
    
    private func removeAnimal(){
        animalName.text = ""
        selectedAnimal.image = nil
        selectedAnimal.isHidden = true
    }
    
    
    func setAnimal(_ animal: AnimalModel){
        //animalName.text = animal.name + "!"
        
        self.selectedAnimal.setAnimalImage(forName: animal, isTransparent: true)
        self.selectedAnimal.isHidden = false
        
        let previouTrasformation = selectedAnimal.transform
        UIView.animate(withDuration: 1,
                       animations: {
                        self.selectedAnimal.transform = self.selectedAnimal.transform.scaledBy(x: 2, y: 2)
                        self.selectedAnimal.alpha = 0.85
                        self.selectedAnimal.layer.cornerRadius = self.radius/2
        },
                       completion: { _ in
                        UIView.animate(withDuration: 1) {
                            self.selectedAnimal.transform  = previouTrasformation
                            self.selectedAnimal.alpha = 0.2
                            //self.selectedAnimal.layer.cornerRadius = self.radius/2
                            self.removeAnimal()
                        }
        })
        
        
    }
    
    
    func setView(isQuestion: Bool){
        centerView.isUserInteractionEnabled = !isQuestion
        rouletteView.isUserInteractionEnabled = isQuestion
       // selectionView.isHidden = isQuestion
    }
    
    func listenSound(animal: AnimalModel?){
        self.playSound(for: animal!)
    }
    
    
    func centeredSelectedCell(by: CGFloat){
        for cell in rouletteView.visibleCells {
            (cell as! RouletteCell).updateAngle(theta: by)
        }
    }
    
    func showRouletteTutorial(show: Bool){
        tutorialView.isHidden = !show
        rouletteTutorialLabel.isHidden = !show
       // externalRoulette.alpha = show ? 0.3 : 1
       // selectionView.alpha = show ? 0.3 : 1
        rouletteView.alpha = show ? 0.3 : 1
    }
    
    func endTutorial(){
        tutorialView.isHidden = true
        rouletteCompleteView.isHidden = false
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    static func push(presenter: UIViewController){
        let viewController = UIStoryboard(name: "AnimalRoulette", bundle: nil).instantiateViewController(withIdentifier: "AnimalRouletteVC") as! AnimalRouletteVC
        presenter.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AnimalRouletteVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouletteCell.identifier, for: indexPath) as! RouletteCell
        cell.config(animals[indexPath.row], index: indexPath.row, angleStep * CGFloat(indexPath.row))
        return cell
    }
}
