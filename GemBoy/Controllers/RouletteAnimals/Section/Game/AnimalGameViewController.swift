//
//  GameViewController.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 01/07/2020.
//  Copyright © 2020 Domenico Gonnelli. All rights reserved.
//

import Foundation
import UIKit

class AnimalGameViewController : AnimalBaseViewController {
    
    private var deck = PlayingBallCollection()
    
    @IBOutlet private var cardViews: [PlayingBallView]!
    
    @IBOutlet weak var collisionView: UIView!
    
    
    lazy var animator = UIDynamicAnimator(referenceView: collisionView)
    lazy var cardBehavior = BallBehavior(in: animator)
    
    var animals : [AnimalModel] = []
    var allAnimals : [AnimalModel] = []
    
    var randomAnimal : AnimalModel?
    var randomIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar?.titleText = homeSection.question.title
        allAnimals = AnimalManager.shared.animals
        self.start()
        UIView.appearance().isExclusiveTouch = true
        
    }
    private func start(isRestart: Bool = false){
        
        let numberOfAnimals = cardViews.count
        self.animals = allAnimals
        let list = allAnimals
        if list.count >= numberOfAnimals {
            let count = list.count - numberOfAnimals
            for _ in 0..<count {
                let randomIndex = Int.random(in: 0..<self.animals.count)
                self.animals.remove(at: randomIndex)
            }
            guard self.animals.count == self.cardViews.count else {return}
            
            self.createRandomAnimal()
            
            for i in 0..<animals.count {
                let ball = cardViews[i]
                ball.animal = animals[i]
                ball.isHidden = false
                ball.isFaceUp = false
                if !isRestart{
                    ball.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
                }
                self.cardBehavior.addItem(ball)
            }
            self.playsound()
        }
    }
    
    
    
    private func createRandomAnimal(){
        randomIndex = Int.random(in: 0..<animals.count)
        randomAnimal = self.animals[randomIndex]
    }
    
    private var faceUpCardViews: [PlayingBallView] {
        return cardViews.filter { $0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1 }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 
    }
    
    var lastChosenCardView: PlayingBallView?
    
    private func playsound(){
        if let randomAnimal = randomAnimal{
            playSound(for: randomAnimal)
        }
    }
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        self.view.isUserInteractionEnabled = true
        switch recognizer.state {
        case .ended:
            if let chosenball = recognizer.view as? PlayingBallView{
                lastChosenCardView = chosenball
                //cardBehavior.removeItem(chosenball)
                UIView.transition(
                    with: chosenball,
                    duration: 0.5,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        chosenball.isFaceUp = !chosenball.isFaceUp
                },
                    completion: { finished in
                        
                        if  chosenball.animal?.name == self.randomAnimal?.name {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    
                                    chosenball.transform = CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0)
                                    
                            },
                                completion: { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            chosenball.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                            chosenball.alpha = 0
                                            
                                    },
                                        completion: {_ in
                                            chosenball.isHidden = true
                                            chosenball.alpha = 1
                                            chosenball.transform = .identity
                                            self.animals.remove(at: self.randomIndex)
                                            if self.animals.count > 0{
                                                self.createRandomAnimal()
                                                self.playsound()}
                                            else {
                                                self.start(isRestart: true)
                                            }
                                            self.view.isUserInteractionEnabled = true
                                    })
                            })
                            
                        } else {
                            UIView.animate(withDuration: 0.5,animations: {
                                chosenball.errorView?.isHidden = false
                                chosenball.errorView?.alpha = 0.8
                                
                            }, completion: {_ in
                                chosenball.errorView?.isHidden = true
                                chosenball.isFaceUp = !chosenball.isFaceUp
                                self.playsound()
                                self.view.isUserInteractionEnabled = true
                            })
                        }
                })
            }
        default:
            break
        }
    }
    
    static func push(presenter: UIViewController){
        let viewController = UIStoryboard(name: "GameBall", bundle: nil).instantiateViewController(withIdentifier: "AnimalGameViewController") as! AnimalGameViewController
        presenter.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func goBack(sender: Any){
        navigationController?.popViewController(animated: true)
    }
}

