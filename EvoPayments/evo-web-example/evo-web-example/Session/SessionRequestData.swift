//
//  SessionRequestData.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import Foundation

/// Data required for example token request in SessionProvider
struct SessionRequestData {
    let tokenUrl: URL
    let action: String?
    let customerID: String
    let customerFirstName: String?
    let customerLastName: String?
    let amount: Double?
    let currency: String?
    let country: String?
    let language: String?
    let userDevice: String?
    let customerAddressHouseName: String?
    let customerAddressStreet: String?
    let customerAddressCity: String?
    let customerAddressPostalCode: String?
    let customerAddressCountry: String?
    let customerAddressState: String?
    let customerEmail: String?
    let customerPhone: String?
    let orderID: String

    let additionalParameters: SessionCustomParameter?

    let merchantNotificationUrl: String?
    let merchantLandingPageUrl: String?
    let allowOriginUrl: String?

    let myriadFlowId: String

    init(tokenUrl: String,
         action: String? = nil,
         customerID: String,
         customerFirstName: String? = nil,
         customerLastName: String? = nil,
         amount: Double? = nil,
         currency: String? = nil,
         country: String? = nil,
         language: String? = nil,
         userDevice: String? = "MOBILE",
         customerAddressHouseName: String? = nil,
         customerAddressStreet: String? = nil,
         customerAddressCity: String? = nil,
         customerAddressPostalCode: String? = nil,
         customerAddressCountry: String? = nil,
         customerAddressState: String? = nil,
         customerEmail: String? = nil,
         customerPhone: String? = nil,
         orderID: String,

         additionalParameters: [String]? = nil,

         //Using same default values as android
         merchantNotificationUrl: String? = Constants.SessionRequest.merchantNotificationUrl.rawValue,
         merchantLandingPageUrl: String? = Constants.SessionRequest.merchantLandingPageUrl.rawValue,
         allowOriginUrl: String? = Constants.SessionRequest.allowOriginUrl.rawValue
        ) {
        self.tokenUrl = URL(string: tokenUrl)!

        self.action = action
        self.customerID = customerID
        self.customerFirstName = customerFirstName
        self.customerLastName = customerLastName
        self.amount = amount
        self.currency = currency
        self.country = country
        self.language = language
        self.userDevice = userDevice
        self.customerAddressHouseName = customerAddressHouseName
        self.customerAddressStreet = customerAddressStreet
        self.customerAddressCity = customerAddressCity
        self.customerAddressPostalCode = customerAddressPostalCode
        self.customerAddressCountry = customerAddressCountry
        self.customerAddressState = customerAddressState
        self.customerEmail = customerEmail
        self.customerPhone = customerPhone
        self.orderID = orderID

        if let additionalParameters = additionalParameters {
            self.additionalParameters = SessionCustomParameter(parameters: additionalParameters)
        } else {
            self.additionalParameters = nil
        }

        self.merchantNotificationUrl = merchantNotificationUrl
        self.merchantLandingPageUrl = merchantLandingPageUrl
        self.allowOriginUrl = allowOriginUrl

        let sessionNumber = Int.random(in: 0...0xFFFFFF)
        var flowId = String.init(sessionNumber, radix: 16, uppercase: true)
        while flowId.count < 6 { flowId.insert("0", at: flowId.startIndex) }
        self.myriadFlowId = "iOS-\(flowId)"
    }

    func toDictionary() -> [String: CustomStringConvertible] {
        var dict: [String: CustomStringConvertible] = [
            "customerId": customerID
        ]

        dict["customerFirstName"] = customerFirstName
        dict["customerLastName"] = customerLastName
        dict["action"] = action
        dict["amount"] = amount
        dict["currency"] = currency
        dict["country"] = country
        dict["language"] = language
        dict["userDevice"] = userDevice
        dict["customerAddressHouseName"] = customerAddressHouseName
        dict["customerAddressStreet"] = customerAddressStreet
        dict["customerAddressCity"] = customerAddressCity
        dict["customerAddressPostalCode"] = customerAddressPostalCode
        dict["customerAddressCountry"] = customerAddressCountry
        dict["customerAddressState"] = customerAddressState
        dict["customerEmail"] = customerEmail
        dict["customerPhone"] = customerPhone
        dict["merchantTxId"] = orderID

        if let additionalParameters = additionalParameters {
            for each in additionalParameters.parameters {
                dict[each.key] = each.value
            }
        }

        dict["merchantNotificationUrl"] = merchantNotificationUrl
        dict["merchantLandingPageUrl"] = merchantLandingPageUrl
        dict["allowOriginUrl"] = allowOriginUrl

        dict["myriadFlowId"] = myriadFlowId

        return dict
    }
}
