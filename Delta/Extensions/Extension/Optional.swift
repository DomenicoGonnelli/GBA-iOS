//
//  Optional.swift
//  Project
//
//  Created by EGONNEDGJ on 21/04/23.
//

import Foundation

extension Optional {
    func `let`<T>(_ transform: (Wrapped) -> T?) -> T? {
        if case .some(let value) = self {
            return transform(value)
        }
        return nil
    }
}
