//
//  DatabaseModelProtocol.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation

protocol DatabaseModelProtocol: DatabaseModelProtocolGet{
    var datafile : Dictionary<String, Any> { get }
}

protocol DatabaseModelProtocolGet {
    init(value: [String: Any])
}

