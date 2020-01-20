//
//  EvoApplePay.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 16/01/2020.
//  Copyright © 2020 Paweł Wojtkowiak. All rights reserved.
//

import Foundation
import PassKit

internal extension Evo {
    struct ApplePayRequest {
        let companyName: String
        let currencyCode: String
        let countryCode: String
        let merchant: String
        let price: String
        let token: String
    }
    
    struct ApplePay {
        func isAvailable() -> Bool {
            return PKPaymentAuthorizationViewController.canMakePayments()// && PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [PKPaymentNetwork.masterCard], capabilities: PKMerchantCapability.capability3DS)
        }
        
        func setupCard() {
            
        }
        
        func setupTransaction(session: Evo.Session, request: Evo.ApplePayRequest) -> PKPaymentRequest {
            let transaction = PKPaymentRequest()
            transaction.currencyCode = request.currencyCode
            transaction.countryCode = request.countryCode
            transaction.merchantIdentifier = request.merchant
            
            transaction.merchantCapabilities = .capability3DS
            
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
