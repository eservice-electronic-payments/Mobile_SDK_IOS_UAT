//
//  AuthenticationRequestParametersProtocol.swift
//  EvoPayments
//
//  Created by Adrian Zyga on 06/10/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import ipworks3ds_sdk

/**
 * Protocol designed to wrap `AuthenticationRequestParametersProtocol` instance.
 * For more info look at [Nsofware SDK documentation](http://cdn.nsoftware.com/help/TS2/mac/default.htm)
 */
protocol AuthenticationRequestParametersProtocol {
    func getDeviceData() -> String
    func getSDKTransactionID() -> String
    func getSDKAppID() -> String
    func getSDKReferenceNumber() -> String
    func getSDKEphemeralPublicKey() -> String
    func getMessageVersion() -> String
    func getAuthRequest() -> String
}

extension AuthenticationRequestParameters: AuthenticationRequestParametersProtocol {}
