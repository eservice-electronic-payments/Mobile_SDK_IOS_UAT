//
//  EvoApplePay.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 16/01/2020.
//  Copyright © 2020 Paweł Wojtkowiak. All rights reserved.
//

import Foundation
import PassKit

extension Evo {
    public struct ApplePayRequest {
        
        ///Init from JSON object from JS
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
        
        #if DEBUG
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
                                   merchant: "Test Merchant",
                                   price: "10.88",
                                   token: "TOKEN",
                                   networks: [.masterCard,.visa],
                                   capabilities: [.capability3DS, .capabilityCredit, .capabilityDebit])
        }
        #endif
    }
    
    struct ApplePay {
        func isAvailable() -> Bool {
            return PKPaymentAuthorizationViewController.canMakePayments()
        }
        
        func hasAddedCard(for network: [PKPaymentNetwork], with capabilities: PKMerchantCapability) -> Bool {
            return PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: network, capabilities: capabilities)
        }
        
        func setupCard() {
            PKPassLibrary().openPaymentSetup()
        }
        
        func setupTransaction(session: Evo.Session, request: Evo.ApplePayRequest) -> PKPaymentRequest {
            let transaction = PKPaymentRequest()
            transaction.currencyCode = request.currencyCode
            transaction.countryCode = request.countryCode
            transaction.merchantIdentifier = request.merchant
            
            transaction.merchantCapabilities = request.capabilities
            transaction.supportedNetworks = request.networks
            
            transaction.applicationData = Data(base64Encoded: request.token)
            
            let locale = Locale(identifier: "en_US_POSIX")
            //Decimal from string would not work with numbers having any kind of decimal separator
            //2,333.33 would become 2 even if using en_US_POSIX or en_US locale
            let fixedString = request.price.replacingOccurrences(of: ",", with: "")
            let subtotal = NSDecimalNumber(string: fixedString, locale: locale)
            
            let total = PKPaymentSummaryItem(label: request.companyName, amount: subtotal, type: .final)
            
            transaction.paymentSummaryItems = [total]
            
            return transaction
        }
        
        func getApplePayController(request: PKPaymentRequest) -> PKPaymentAuthorizationViewController? {
            return PKPaymentAuthorizationViewController(paymentRequest: request)
        }
    }
}
