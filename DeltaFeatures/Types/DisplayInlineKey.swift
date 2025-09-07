//
//  DisplayInlineKey.swift
//  DeltaFeatures
//
//  Created by Darlion on 4/11/23.
//  Copyright © 2023 Riley Testut. All rights reserved.
//

import SwiftUI

public struct DisplayInlineKey: PreferenceKey
{
    public static var defaultValue: Bool = false
    
    public static func reduce(value: inout Bool, nextValue: () -> Bool)
    {
        value = nextValue()
    }
}

public extension View
{
    func displayInline(_ value: Bool = true) -> some View
    {
        self.preference(key: DisplayInlineKey.self, value: value)
    }
}
