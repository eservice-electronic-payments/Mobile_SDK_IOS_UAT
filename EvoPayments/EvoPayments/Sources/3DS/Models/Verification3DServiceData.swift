//
//  Verification3DServiceData.swift
//  EvoPayments
//
//  Created by Adrian Zyga on 08/09/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

/**
 * Structure designed to gether all the data needed to initialize `ThreeDS2VerificationService`.
 * All data is passed to the `TransactionBuilderProtocol`
 * For more info look at [Nsofware SDK documentation](http://cdn.nsoftware.com/help/TS2/mac/default.htm)
 */
struct Verification3DServiceData {
    let RID: String
    let publicKey: String
    // swiftlint:disable:next identifier_name
    let CA: String
    let clientConfigs: [String]
    let runtimeLicense: String
    let configParameters: [String: String]
    let directoryServerID: String
    let messageVersion: String
}
