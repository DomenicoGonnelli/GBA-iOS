//
//  Loader.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//

import Foundation
import Lottie
import UIKit


class Loader: BaseView{
    
    override var nibName: String?{
        return "Loader"
    }
    
    let animationName = "loaderFF"
    
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var animationView : LottieAnimationView!
    
    var loaderDesctiption : String?{
        didSet{
            if let description = loaderDesctiption{
                descriptionLabel.text = description
                descriptionLabel.isHidden = false
            }else {
                descriptionLabel.isHidden = true
            }
        }
    }
    
    func setAnimation(){
        let animation = LottieAnimation.named(animationName)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animation = animation
        animationView.animationSpeed = 2
    }
    
    func startAnimation(){
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }
    
    func stopAnimation(){
        animationView.stop()
    }
    
    
    static func createLoader(viewController: UIViewController?, backgroundColor: UIColor = .clear) -> Loader?{
        guard let viewController = viewController else {
            return nil
        }
        
        let loader = Loader.init(frame: viewController.view.frame)
        loader.backgroundColor = backgroundColor
        loader.setAnimation()
        viewController.view.addSubview(loader)
        viewController.view.bringSubviewToFront(loader)
        return loader
    }
    
}


