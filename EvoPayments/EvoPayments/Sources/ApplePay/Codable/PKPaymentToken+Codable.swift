//
//  PKPaymentToken+Codable.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 04/03/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation
import PassKit

extension PKPaymentToken: Encodable {
    enum CodingKeys: String, CodingKey {
        case paymentMethod
        case transactionIdentifier
        case paymentData
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(paymentMethod, forKey: .paymentMethod)
        try container.encode(transactionIdentifier, forKey: .transactionIdentifier)

        //  Decode token to Base64 string (UTF8)
        let tokenString = paymentData.base64EncodedString()
        try container.encode(tokenString, forKey: .paymentData)

    }
}
