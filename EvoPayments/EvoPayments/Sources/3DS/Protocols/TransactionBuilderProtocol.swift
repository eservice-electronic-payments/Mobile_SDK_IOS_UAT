//
//  TransactionBuilderProtocol.swift
//  EvoPayments
//
//  Created by Adrian Zyga on 02/09/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import ipworks3ds_sdk

/**
 * Protocol designed to wrap `ThreeDS2Service` instance.
 * For more info look at [Nsofware SDK documentation](http://cdn.nsoftware.com/help/TS2/mac/default.htm)
 */
protocol TransactionBuilderProtocol {

    func initialize(
        configParameters: ConfigParameters?,
        locale: String?,
        uiCustomization: UiCustomization?,
        clientEventListener: ClientEventListener?,
        securityEventListener: SecurityEventListener?
    ) throws

    /**
     * This protocol should be used to wrap around the original `createTransaction`
     * method to avoid the ambiguous naming error
     */
    func createTransactionProtocol(
        _ directoryServerID: String, _ messageVersion: String?
    ) throws -> TransactionProtocol
}

extension ThreeDS2Service: TransactionBuilderProtocol {
    /// This method wraps around the original `createTransaction` method to avoid the ambiguous naming error
    func createTransactionProtocol(
        _ directoryServerID: String,
        _ messageVersion: String?
    ) throws -> TransactionProtocol {
        return try createTransaction(directoryServerID, messageVersion)
    }
}
