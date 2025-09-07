//
//  Features.swift
//  Delta
//
//  Created by Darlion on 4/21/23.
//  Copyright © 2023 Riley Testut. All rights reserved.
//

import GemBoyFeatures

extension Settings
{
    struct Features: FeatureContainer
    {
        static let shared = Features()
        
        @Feature(name: "DS AirPlay", options: DSAirPlayOptions())
        var dsAirPlay
        
        private init()
        {
            self.prepareFeatures()
        }
    }
}
