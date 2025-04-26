//
//  ChartCell.swift
//  Project
//
//  Created by EGONNEDGJ on 20/01/24.
//

import Foundation

import UIKit

class ChartCell: UITableViewCell{
    
    static var indetifier = "ChartCell"
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var sectionLabel : UILabel!
    @IBOutlet var singerName : [UILabel]!
    @IBOutlet var singerPercent : [NSLayoutConstraint]!
    @IBOutlet var singerPercentContainer : [UIView]!
    var percentWidth : CGFloat = 0
    
    func configureView(_ item: ChartModel?){
        guard singerName.count == singerPercent.count else {return}
        self.percentWidth = contentView.frame.width - 24*2 - 12 - 40
        titleLabel.localizedKey = item?.title
        sectionLabel.localizedKey = item?.section
        if let item = item {
            let list = item.data
            for i in 0..<list.count {
                self.singerName[i].superview?.isHidden = false
                self.singerName[i].localizedKey = list[i].singerID
                let percent = list[i].percent ?? 0
                self.singerPercent[i].constant = 0
                UIView.animate(withDuration: 0.2, delay: 0.3, animations: {}, completion: { _ in
                    self.singerPercent[i].constant = self.percentWidth*CGFloat(percent)/100
                    UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 0.3,
                                   initialSpringVelocity: 0.8, options: []){
                        self.singerPercentContainer[i].layoutIfNeeded()
                    }})
                }
                
            }
        }
    }

