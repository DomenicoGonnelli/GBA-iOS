//
//  IAPProduct.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation

public enum IAPProduct: String, CaseIterable {
    
    case premiumMonthly = "com.domenico.gonnelli.farm.gba.month",
         premiumAnnual = "com.domenico.gonnelli.farm.gba.annual",
         premiumJFR = "com.domenico.gonnelli.farm.gba.jfr"
    
    private static var productIdentifiers: Set<ProductIdentifier> {
        var ids : Set<ProductIdentifier> = []
        
        if let allID = AppManager.shared.homeData?.premiumConfig?.premiumListId {
            for id in allID {
                ids.insert(id)
            }
        } else {
            for id in IAPProduct.allCases {
                ids.insert(id.rawValue)
            }
        }
        return ids
    }
    
    public static let store = IAPHelper(productIds: IAPProduct.productIdentifiers)
    
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
