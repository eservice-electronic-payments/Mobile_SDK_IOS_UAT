//
//  TransactionProtocol.swift
//  EvoPayments
//
//  Created by Adrian Zyga on 06/10/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import ipworks3ds_sdk

/**
 * Protocol designed to wrap `Transaction` instance.
 * For more info look at [Nsofware SDK documentation](http://cdn.nsoftware.com/help/TS2/mac/default.htm)
 */
protocol TransactionProtocol {
    /**
     * This protocol should be used to wrap around the original `getAuthenticationRequestParameters`
     * method to avoid the ambiguous naming error
     */
    func getAuthenticationRequestParametersProtocol() throws -> AuthenticationRequestParametersProtocol
    func doChallenge(
        rootViewController: UIViewController,
        challengeParameters: ChallengeParameters,
        challengeStatusReceiver: ChallengeStatusReceiver,
        timeout: Int
    ) throws
    func close() throws
}

extension Transaction: TransactionProtocol {
    /// This method wraps around the original `getAuthenticationRequestParameters` to avoid the ambiguous naming error
    func getAuthenticationRequestParametersProtocol() throws -> AuthenticationRequestParametersProtocol {
        return try getAuthenticationRequestParameters()
    }
}
