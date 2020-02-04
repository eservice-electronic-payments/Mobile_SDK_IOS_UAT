//
//  ApplePayRequest.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 04/02/2020.
//  Copyright © 2020 Paweł Wojtkowiak. All rights reserved.
//

import Foundation
import PassKit

extension Evo {
    struct ApplePayRequest {
        
        ///Init from JSON object
        init?(json: [String:Any]) {
            guard let companyName: String = json["companyName"] as? String else {
                dLog("companapplePay Request yName nil")
                return nil
            }
            self.companyName = companyName

            guard let currencyCode: String = json["currencyCode"] as? String else {
                dLog("currencapplePay Request yCode nil")
                return nil
            }
            self.currencyCode = currencyCode

            guard let countryCode: String = json["countryCode"] as? String else {
                dLog("countrapplePay Request yCode nil")
                return nil
            }
            self.countryCode = countryCode

            //Merchant needs to match the apple merchant identifier
            guard let merchant: String = json["merchant"] as? String else {
                dLog("merapplePay Request chant nil")
                return nil
            }
            self.merchant = merchant

            guard let price: String = json["price"] as? String else {
                dLog("applePay Request price nil")
                return nil
            }
            self.price = price

            guard let token: String = json["token"] as? String else {
                dLog("applePay Request token nil")
                return nil
            }
            self.token = token
            
            //TODO: Define mapping
            guard let networks: [String] = json["networks"] as? [String] else {
                dLog("applePay Request token nil")
                return nil
            }
            let paymentNetworks = networks.map{ PKPaymentNetwork(rawValue: $0) }
            self.networks = paymentNetworks
            
            //TODO: Define mapping
            guard let capabilities: UInt = json["capabilities"] as? UInt else {
                dLog("applePay Request token nil")
                return nil
            }
            let merchantCapability = PKMerchantCapability(rawValue: capabilities)
            self.capabilities = merchantCapability
            
        }
        
        let companyName: String
        let currencyCode: String
        let countryCode: String
        let merchant: String
        let price: String
        let token: String
        let networks: [PKPaymentNetwork]
        let capabilities: PKMerchantCapability
        
//        #if DEBUG
        private init(companyName: String, currencyCode: String, countryCode: String, merchant: String, price: String, token: String, networks: [PKPaymentNetwork], capabilities: PKMerchantCapability) {
            self.companyName = companyName
            self.currencyCode = currencyCode
            self.countryCode = countryCode
            self.merchant = merchant
            self.price = price
            self.token = token
            self.networks = networks
            self.capabilities = capabilities
        }
        
        static func dummyData() -> Self {
            return ApplePayRequest(companyName: "Test",
                                   currencyCode: "USD",
                                   countryCode: "US",
                                   merchant: "merchant.com.valentinourbano.testApplePay",
                                   price: "10.88",
                                   token: "TOKEN",
                                   networks: [.masterCard, .visa],
                                   capabilities: [.capability3DS, .capabilityCredit, .capabilityDebit])
        }
//        #endif
    }
    
}
