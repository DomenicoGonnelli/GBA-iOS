//
//  RankingStarView.swift
//  Vodafone LEAN
//
//  Created by Gonnelli Domenico on 09/05/21.
//  Copyright © 2021 NTT DATA. All rights reserved.
//

import Foundation
import UIKit

class RankingStarView: UIView {
    public static let nibName = "RankingStarView"
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBInspectable var selectedImage: UIImage?
    @IBInspectable var unselectedImage: UIImage?
    
    @IBInspectable var elementSpacing: CGFloat = 20{
        didSet{
            stackView.spacing = elementSpacing
        }
    }
    
    @IBInspectable var rank: Int = 0 {
        didSet{
            configureStackView()
        }
    }
    
    var contentView: UIView?
    var delegate : RankingStarViewDelegate?
    
    var starButton : [UIButton] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        configureStackView()
        
    }
    
    func configureStackView(){
        if starButton.count < rank{
            for i in 0..<rank {
                let button = UIButton()
                button.setImage(unselectedImage, for: .normal)
                button.addTarget(self, action: #selector(onStarTapped), for: .touchUpInside)
                button.tag = i
                starButton.append(button)
                stackView.addArrangedSubview(button)
            }
        }
        
    }
    
    @objc func onStarTapped(sender: UIButton){
        setSelectedRank(to: sender.tag)
        
        delegate?.selectedRanking(with: sender.tag)
    }

    func setSelectedRank(to index: Int){
        for i in 0..<starButton.count{
            if i <=  index {
                starButton[i].setImage(selectedImage, for: .normal)
            } else {
                starButton[i].setImage(unselectedImage, for: .normal)
            }
        }
    }
    
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: RankingStarView.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}

protocol RankingStarViewDelegate {
    func selectedRanking(with value: Int)
}
