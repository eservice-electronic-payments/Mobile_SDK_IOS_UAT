//
//  ApplePayRequest.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 04/02/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation
import PassKit

struct ApplePayRequest {

    ///  Init from JSON object
    init?(json: [String: Any]) {
        guard let companyName: String = json["companyName"] as? String else {
            dLog("companapplePay Request yName nil")
            return nil
        }
        self.companyName = companyName

        //  3 digits
        guard let currencyCode: String = json["currencyCode"] as? String else {
            dLog("currencapplePay Request yCode nil")
            return nil
        }
        self.currencyCode = currencyCode

        //  2 digits
        guard let countryCode: String = json["countryCode"] as? String else {
            dLog("countrapplePay Request yCode nil")
            return nil
        }
        self.countryCode = countryCode

        //  Merchant needs to match the apple merchant identifier
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

        guard let networks: [String] = json["networks"] as? [String] else {
            dLog("applePay Request networks nil")
            return nil
        }
        let networkMapper = PKPaymentNetworkMapper()
        let paymentNetworks = networks.map { networkMapper.network(from: $0) }
        self.networks = paymentNetworks

        guard let capabilities: [String] = json["capabilities"] as? [String] else {
            dLog("applePay Request capabilities nil")
            return nil
        }
        let capabilityMapper = PKMerchantCapabilityMapper()
        guard let merchantCapability = capabilityMapper.capability(from: capabilities) else {
            dLog("applePay Request capabilities not mappable to PKMerchantCapability")
            return nil
        }
        self.capabilities = merchantCapability

    }

    let companyName: String
    let currencyCode: String
    let countryCode: String
    let merchant: String
    let price: String
    let networks: [PKPaymentNetwork]
    let capabilities: PKMerchantCapability
}
