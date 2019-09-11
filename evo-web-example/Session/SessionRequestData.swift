//
//  SessionRequestData.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

/// Data required for example token request in SessionProvider
struct SessionRequestData {
    let tokenUrl: URL
    let action: String?
    let merchantID: String
    let merchantPassword: String?
    let customerID: String
    let amount: Double?
    let currency: String?
    let country: String?
    let language: String?
    let myriadFlowId: String
    
    init(tokenUrl: String,
         action: String? = nil,
         merchantID: String,
         merchantPassword: String? = nil,
         customerID: String,
         amount: Double? = nil,
         currency: String? = nil,
         country: String? = nil,
         language: String? = nil) {
        self.tokenUrl = URL(string: tokenUrl)!
        
        self.action = action
        self.merchantID = merchantID
        self.merchantPassword = merchantPassword
        self.customerID = customerID
        self.amount = amount
        self.currency = currency
        self.country = country
        self.language = language
        
        let sessionNumber = Int.random(in: 0...0xFFFFFF)
        var flowId = String.init(sessionNumber, radix: 16, uppercase: true)
        while flowId.count < 6 { flowId.insert("0", at: flowId.startIndex) }
        self.myriadFlowId = "iOS-\(flowId)"
    }
    
    func toDictionary() -> [String: CustomStringConvertible] {
        var dict: [String: CustomStringConvertible] = [
            "merchantId": merchantID,
            "customerId": customerID
        ]
        
        dict["action"] = action
        dict["password"] = merchantPassword
        dict["amount"] = amount
        dict["currency"] = currency
        dict["country"] = country
        dict["language"] = language
        dict["myriadFlowId"] = myriadFlowId
        
        return dict
    }
}
