//
//  GameViewController+ExperimentalToasts.swift
//  Delta
//
//  Created by Chris Rittenhouse on 4/26/23.
//  Copyright © 2023 Riley Testut. All rights reserved.
//

import Roxas
import Foundation

extension UIViewController
{
    func presentExperimentalToastView(_ text: String, duration: Double? = nil)
    {
        let time = duration ?? ExperimentalFeatures.shared.toastNotifications.duration
        guard ExperimentalFeatures.shared.toastNotifications.isEnabled else { return }
        
        DispatchQueue.main.async {
            let toastView = RSTToastView(text: text, detailText: nil)
            toastView.edgeOffset.vertical = 8
            toastView.textLabel.textAlignment = .center
            toastView.presentationEdge = .top
            toastView.show(in: self.view, duration: time)
        }
    }
}

extension UIPresentationController
{
    func presentExperimentalToastView(_ text: String, duration: Double? = nil)
    {
        let time = duration ?? ExperimentalFeatures.shared.toastNotifications.duration
        guard ExperimentalFeatures.shared.toastNotifications.isEnabled else { return }
        
        DispatchQueue.main.async {
            let toastView = RSTToastView(text: text, detailText: nil)
            toastView.edgeOffset.vertical = 8
            toastView.textLabel.textAlignment = .center
            toastView.presentationEdge = .top
            if let cv = self.containerView {
                toastView.show(in: cv, duration: time)
            }
        }
    }
}

