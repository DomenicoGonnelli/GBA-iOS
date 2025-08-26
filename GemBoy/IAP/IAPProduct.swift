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
    
    private static let productIdentifiers: Set<ProductIdentifier> = [
        IAPProduct.premiumMonthly.rawValue,
        IAPProduct.premiumAnnual.rawValue,
        IAPProduct.premiumJFR.rawValue,
    ]
    
    public static let store = IAPHelper(productIds: IAPProduct.productIdentifiers)
    
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
