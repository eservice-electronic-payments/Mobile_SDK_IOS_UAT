//
//  PKPaymentMethodTypeMapper.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 04/03/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation
import PassKit

extension PKPaymentMethodType {
    var stringValue: String {
        switch self {
        case .credit:
            return "Credit"
        case .debit:
            return "Debit"
        case .prepaid:
            return "Prepaid"
        case .store:
            return "Store"
        default:
            return "Unknown"
        }
    }
}

#if DEBUG

//Can't have automatic conformance
extension PKPaymentMethodType: CaseIterable {
    public static var allCases: [PKPaymentMethodType] {
        return [.credit, .debit, .prepaid, .store, .unknown]
    }
}

struct PKPaymentTypeMapper {
    //Debug only - To be able to initialize from a rawValue each time Apple adds a new card
    //it needs to be mapped on the server to be able to be passed in to the sdk.
    static func debugPrint() {
        for each in PKPaymentMethodType.allCases {
            print(each.rawValue)
        }
   }
}
#endif
