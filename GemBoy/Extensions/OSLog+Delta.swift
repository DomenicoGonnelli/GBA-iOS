//
//  OSLog+Delta.swift
//  Delta
//
//  Created by Riley Testut on 8/10/23.
//  Copyright © 2023 Riley Testut. All rights reserved.
//

@_exported import OSLog

extension OSLog.Category
{
    static let main = "Main"
    static let database = "Database"
    static let purchases = "Purchases"
}

extension Logger
{
    static let deltaSubsystem = "com.rileytestut.Delta"
    
    static let main = Logger(subsystem: deltaSubsystem, category: OSLog.Category.main)
    static let database = Logger(subsystem: deltaSubsystem, category: OSLog.Category.database)
    static let purchases = Logger(subsystem: deltaSubsystem, category: OSLog.Category.purchases)
}

@available(iOS 15, *)
extension OSLogEntryLog.Level
{
    var localizedName: String {
        switch self
        {
        case .undefined: return "Undefined".localizable
        case .debug: return "Debug".localizable
        case .info: return "Info".localizable
        case .notice: return "Notice".localizable
        case .error: return "Error".localizable
        case .fault: return "Fault".localizable
        @unknown default: return "Unknown".localizable
        }
    }
}
