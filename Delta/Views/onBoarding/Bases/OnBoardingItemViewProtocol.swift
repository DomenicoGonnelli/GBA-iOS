//
//  OnBoardingItemViewProtocol.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 12/01/23.
//

import Foundation
import UIKit
import Lottie
import Kingfisher

class OnBoardingBaseViewController: UIViewController, OnBoardingItemViewProtocol{
    var onBoardingItem : OnBoardingGenericItem?
    
    @IBOutlet weak var onBoardingTitle: UILabel!
    @IBOutlet weak var onBoardingBody: UILabel!
    @IBOutlet weak var onBoardingImage: UIImageView!
    @IBOutlet weak var onBoardingBGImage: UIImageView!
    @IBOutlet weak var animationView: LottieAnimationView!
   
    var lineSpace: CGFloat = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onBoardingTitle.textColor = onBoardingItem?.texColor
        onBoardingTitle.setAttributedWithTag(text: onBoardingItem?.title)
        
        let imageName = onBoardingItem?.imageName ?? ""
        onBoardingImage.image = UIImage(named: imageName)
        
        if imageName.contains("http"), let url = URL(string: imageName) {
            onBoardingImage.kf.setImage(with: url)
        }
        
        
        if let anim = onBoardingItem?.animationName {
            if anim.contains("http"), let url = URL(string: anim) {
                Task {
                    await setAnimation(url: url)
                }
            } else {
                setAnimation(name: anim)
            }
        }
        onBoardingBody.textColor = onBoardingItem?.texColor
        if onBoardingItem?.delegate != nil {
            onBoardingBody.setAttributedWithTag(text: onBoardingItem?.body, lineSpace: lineSpace)
            onBoardingBody.addLinkWithAction(linkKey: onBoardingItem?.linkKey, fontSize: 16, target: self, action: #selector(onLinkTapped(gesture:)))
            onBoardingBody.layoutIfNeeded()
        } else {
            onBoardingBody.text = onBoardingItem?.body
        }
        
       
        
    }
    
    func setAnimation(name: String){
        let animation = LottieAnimation.named(name)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animation = animation
        animationView.animationSpeed = 1
        animationView.play()
    }
    
    func setAnimation(url: URL) async{
        let animation = await LottieAnimation.loadedFrom(url: url)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animation = animation
        animationView.animationSpeed = 1
        animationView.play()
    }

    
    @objc func onLinkTapped(gesture: UITapGestureRecognizer) {
        
        
    }
    
}
