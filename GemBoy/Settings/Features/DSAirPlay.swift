//
//  DSAirPlay.swift
//  Delta
//
//  Created by Riley Testut on 4/26/23.
//  Copyright © 2023 Riley Testut. All rights reserved.
//

import SwiftUI

import GemBoyFeatures
import DeltaCore

extension TouchControllerSkin.LayoutAxis: OptionValue {}

struct DSAirPlayOptions
{
    @Option
    var topScreenOnly: Bool = true
    
    @Option
    var layoutAxis: TouchControllerSkin.LayoutAxis = .vertical
}
