//
//  Collection+Optionals.swift
//  DeltaFeatures
//
//  Created by Darlion on 4/12/23.
//  Copyright © 2023 Riley Testut. All rights reserved.
//

import Foundation

extension Collection
{
    func appendingNil() -> [Element] where Element: OptionalProtocol, Element.Wrapped: LocalizedOptionValue
    {
        var values = Array(self)
        values.append(Element.none)
        return values
    }
}
