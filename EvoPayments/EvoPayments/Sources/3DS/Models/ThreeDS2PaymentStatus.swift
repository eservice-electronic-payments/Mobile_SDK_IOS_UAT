//
//  ThreeDS2PaymentStatus.swift
//  EvoPayments
//
//  Created by Adrian Zyga on 29/09/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

/**
 *  Struct with the status of the payment, in a format easly
 *  decodable to JSON (specifically prepared for the webview)
 */
struct ThreeDS2PaymentStatus: Codable {
    let transactionID: String?
    let status: String?
    let errorCode: String?
    let errorDescription: String?
    let errorDetails: String?
    let errorMessage: String?
}
