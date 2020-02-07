//
//  PKMerchantCapabilityMapper.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 07/02/2020.
//  Copyright © 2020 Paweł Wojtkowiak. All rights reserved.
//

import Foundation
import PassKit

struct PKMerchantCapabilityMapper {
    func capability(from string: String) -> PKMerchantCapability? {
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
