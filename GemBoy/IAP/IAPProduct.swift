//
//  IAPProduct.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation

public enum IAPProduct: String, CaseIterable {
    
    case premiumMonthly = "com.domenico.gonnelli.purple.month",
         premiumAnnual = "com.domenico.gonnelli.purple.annual"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [IAPProduct.premiumMonthly.rawValue, IAPProduct.premiumAnnual.rawValue]
    
    public static let store = IAPHelper(productIds: IAPProduct.productIdentifiers)
    
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
