//
//  IPGSessionTokenRequestData.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

public extension IPG {
    public struct SessionTokenRequestData {
        enum Action: String {
            case capture = "CAPTURE"
            case auth = "AUTH"
            case purchase = "PURCHASE"
        }
        
        enum Channel: String {
            case ecommerce = "ECOM"
            case moto = "MOTO"
        }
        
        enum PaymentSolution: Int {
            case card = 500
        }
        
        let merchantID: Int
        let password: String
        let allowOriginUrl: String
        let action: Action
        let channel: Channel
        let timestamp: Int
        let amount: String // BigDecimal
        let currency: String
        let country: String
        let paymentSolution: PaymentSolution
        
        let customerID: String?
        
        init(merchantID: Int,
             password: String,
             allowOriginUrl: String,
             action: Action = .auth,
             channel: Channel = .moto,
             amount: String,
             currency: String,
             country: String,
             paymentSolution: PaymentSolution = .card,
             customerID: String? = nil,
             timestamp: Int? = nil) {
            
            self.merchantID = merchantID
            self.password = password
            self.allowOriginUrl = allowOriginUrl
            self.action = action
            self.channel = channel
            self.timestamp = timestamp ?? Int(Date().timeIntervalSince1970*1000)
            self.amount = amount
            self.currency = currency
            self.country = country
            self.paymentSolution = paymentSolution
            
            self.customerID = customerID
            
        }
    }
}

extension IPG.SessionTokenRequestData {
    static let testUser = IPG.SessionTokenRequestData(merchantID: 666,
                                                      password: "RfuYGUEswQ3dUvMSxyC80PuHZFdcjPZW",
                                                      allowOriginUrl: "test",
                                                      action: .auth,
                                                      channel: .moto,
                                                      amount: "123",
                                                      currency: "GBP",
                                                      country: "GB",
                                                      customerID: "qsFCD3lPESfMoSNTGsfZ")
}
