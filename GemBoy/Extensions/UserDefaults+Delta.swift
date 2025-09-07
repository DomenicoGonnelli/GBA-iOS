//
//  UserDefaults+Delta.swift
//  Delta
//
//  Created by Darlion on 8/10/23.
//  Copyright © 2023 Riley Testut. All rights reserved.
//

import Foundation

extension UserDefaults
{
    @NSManaged var shouldRepairDatabase: Bool
    
    @NSManaged var patronsRefreshID: String?
    @NSManaged var shouldFetchFriendZonePatrons: Bool
    
    @NSManaged var isExternalPurchaseLinkDisabled: Bool
    
    @NSManaged var didShowChooseWFCServerAlert: Bool
    
    @NSManaged var didShowWhatsNew: Bool
}
