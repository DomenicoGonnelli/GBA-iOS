//
//  QuizQuestion.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 05/02/23.
//

import Foundation

import UIKit

class QuizQuestion: BaseViewController {
    
    static let identifier = "QuizSplashViewController"
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    
    static func instance() -> QuizSplashViewController{
        let vc = UIStoryboard(name: "QuizSplash", bundle: nil).instantiateViewController(withIdentifier: identifier) as! QuizSplashViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func push(prensenter: UIViewController?, image: UIImage?) {
        let vc = instance()
        prensenter?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension QuizSplashViewController{
    
    
    func show(completion: @escaping (()->Void)) {
        if LoginManager.shared.user?.extraMoney != 3 {
            showADB(){ completion() }
        } else {
            completion()
            print("Ad wasn't ready")
        }
    }
    
    func loadRewardedAd() {
        if LoginManager.shared.user?.extraMoney != 3 {
            refreshInterstitial()
        }
    }
    
    
}
