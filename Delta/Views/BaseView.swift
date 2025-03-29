//
//  BaseVie.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//

import Foundation
import UIKit

class BaseView: UIView, GenericCustomViewProtocol{
    
    var nibName: String?{
        return ""
    }
    
    var contentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
     func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        guard let nibName = nibName else { return nil}
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}

protocol GenericCustomViewProtocol {
    var nibName : String? { get }
}
