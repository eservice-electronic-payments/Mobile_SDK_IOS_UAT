//
//  ThreeDS2Challenge.swift
//  EvoPayments
//
//  Created by Adrian Zyga on 29/09/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

/**
 * Data to initiate the challenge recived from the webview
 * For more info look at [Nsofware SDK documentation](http://cdn.nsoftware.com/help/TS2/mac/default.htm)
 */
struct ThreeDS2Challenge: Codable {
    let threeDSServerTransactionID: String
    let acsTransactionID: String
    let acsRefNumber: String
    let acsSignedContent: String

    private enum CodingKeys: String, CodingKey {
        case threeDSServerTransactionID = "3DSServerTransactionID"
        case acsTransactionID = "AcsTransactionID"
        case acsRefNumber = "AcsRefNumber"
        case acsSignedContent = "AcsSignedContent"
    }
}
