//
//  PKMerchantCapabilityMapper.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 07/02/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation
import PassKit

struct PKMerchantCapabilityMapper {
    func capability(from array: [String]) -> PKMerchantCapability? {
        var capability = PKMerchantCapability()
        for each in array {
            if let newCapability = convert(from: each) {
                capability.formUnion(newCapability)
            }
        }
        return capability
    }

    private func convert(from string: String) -> PKMerchantCapability? {
        switch string {
        case "3DS":
          return .capability3DS
        case "EMV":
          return .capabilityEMV
        case "Credit":
          return .capabilityCredit
        case "Debit":
          return .capabilityDebit
        default:
          dLog("Unrecognized merchant capability: \(string)")
          return nil
        }
    }
}
