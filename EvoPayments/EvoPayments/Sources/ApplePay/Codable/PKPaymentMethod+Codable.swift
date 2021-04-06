//
//  PKPaymentMethod+Codable.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 04/03/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation
import PassKit

extension PKPaymentMethod: Encodable {
    enum CodingKeys: String, CodingKey {
        case displayName
        case network
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(displayName, forKey: .displayName)
        if let network = network?.rawValue {
            try container.encode(network, forKey: .network)
        }
        try container.encode(type.stringValue, forKey: .type)

    }
}
