//
//  Encodable+convertToJSONString.swift
//  EvoPayments
//
//  Created by Adrian Zyga on 30/09/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation

extension Encodable {
    func convertToJSONString() throws -> String {
        let jsonData = try JSONEncoder().encode(self)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw EventError.invalidParameters("Cannot convert JSON to String")

        }
        return jsonString
    }
}
