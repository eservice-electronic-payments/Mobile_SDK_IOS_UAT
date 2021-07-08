//
//  PaymentRequest.swift
//  EvoPayments
//
//  Created by Adrian Zyga on 18/09/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation

/**
 * Structure designed to gether all the data from the `TransactionProtocol` instance,
 * for the webview, so that the webview can generate a challenge. This Request should be generted by using
 * `generateRequest()` method of `ThreeDS2VerificationServiceProtocol`
 * For more info look at [Nsofware SDK documentation](http://cdn.nsoftware.com/help/TS2/mac/default.htm)
 */
struct PaymentRequest: Codable {
    let sdkTransactionId: String
    let deviceData: String
    let sdkEphemeralPublicKey: SDKEphemeralPublicKey
    let sdkAppId: String
    let sdkReferenceNumber: String
    let protocolVersionSDK: String

    private enum CodingKeys: String, CodingKey {
        case sdkTransactionId = "SDKTransactionId"
        case deviceData = "DeviceData"
        case sdkEphemeralPublicKey = "SDKEphemeralPublicKey"
        case sdkAppId = "SDKAppId"
        case sdkReferenceNumber = "SDKReferenceNumber"
        case protocolVersionSDK = "SDKProtocolVersion"
    }
}

struct SDKEphemeralPublicKey: Codable {
    let kty: String
    let crv: String
    let x: String // swiftlint:disable:this identifier_name
    let y: String // swiftlint:disable:this identifier_name
    let d: String? // swiftlint:disable:this identifier_name

    init(data: Data) throws {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(SDKEphemeralPublicKey.self, from: data)
        self = decoded
    }
}
