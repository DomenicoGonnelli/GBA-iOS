//
//  GameView+AirPlay.swift
//  Delta
//
//  Created by Darlion on 11/1/23.
//  Copyright © 2023 Riley Testut. All rights reserved.
//

import Foundation
import ObjectiveC.runtime

import GameCore
import Roxas

private var airPlayViewKey = 0

extension GameView
{
    var isAirPlaying: Bool {
        get { self.airPlayView != nil }
        set {
            guard newValue != self.isAirPlaying else { return }
            
            if newValue
            {
                self.showAirPlayView()
            }
            else
            {
                self.hideAirPlayView()
            }
        }
    }
}

private extension GameView
{
    weak var airPlayView: UIView? {
        get { objc_getAssociatedObject(self, &airPlayViewKey) as? UIView }
        set { objc_setAssociatedObject(self, &airPlayViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN) }
    }
    
    func showAirPlayView()
    {
        guard self.airPlayView == nil else { return }
        
        let placeholderView = RSTPlaceholderView(frame: .zero)
        placeholderView.backgroundColor = .black
        
        placeholderView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        placeholderView.textLabel.text = "AirPlay".localizable
        placeholderView.textLabel.textColor = .systemGray
        placeholderView.textLabel.numberOfLines = 1 // Enforce single line
        
        placeholderView.detailTextLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        placeholderView.detailTextLabel.text = "AirPlay_second_screen".localizable
        placeholderView.detailTextLabel.textColor = .systemGray
        
        let config = UIImage.SymbolConfiguration(pointSize: 100)
        let airPlayIcon = UIImage(systemName: "tv", withConfiguration: config)
        placeholderView.imageView.image = airPlayIcon
        placeholderView.imageView.isHidden = false
        placeholderView.imageView.tintColor = .systemGray
        
        self.addSubview(placeholderView, pinningEdgesWith: .zero)
        
        // Ensure label goes to edge before wrapping to new line.
        NSLayoutConstraint.activate([
            placeholderView.detailTextLabel.leadingAnchor.constraint(equalTo: placeholderView.layoutMarginsGuide.leadingAnchor),
            placeholderView.detailTextLabel.trailingAnchor.constraint(equalTo: placeholderView.layoutMarginsGuide.trailingAnchor),
        ])
        
        self.airPlayView = placeholderView
    }
    
    func hideAirPlayView()
    {
        guard let airPlayView else { return }
        
        airPlayView.removeFromSuperview()
        
        self.airPlayView = nil
    }
}
