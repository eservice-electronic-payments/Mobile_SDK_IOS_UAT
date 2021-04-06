//
//  ThreeDS2Error.swift
//  EvoPayments
//
//  Created by Adrian Zyga on 18/09/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import ipworks3ds_sdk

/**
 * Enum that gathers both public NSoftware SDK errors and other errors that may
 * occur during the payment inside EvoPayments while using `ThreeDS2VerificationServiceProtocol`
 */
enum ThreeDS2Error: Error {
    case unknown(Error)
    case cancelled
    case timedout
    case protocolError(errorCode: String, errorDescription: String, errorDetails: String, transactionID: String)
    case runtimeError(errorCode: String?, errorMessage: String)

    /**
     * This tuple returns error in `ThreeDS2PaymentStatus` format readable by webview and error in `EventType`
     * format that is used to update the UI. Tuple was chosen instead of two separate computed variables,
     * so that the switch is executed only once for both, as both are needed either way.
     */
    var paymentInfo: (paymentStatus: ThreeDS2PaymentStatus, eventType: EventType) {
        switch self {
        case .unknown(let error):
            return generatePaymentInfo(
                eventType: .status(.failed),
                status: "error",
                errorDescription: error.localizedDescription,
                errorMessage: "unknown"
            )
        case .cancelled:
            return generatePaymentInfo(
                eventType: .status(.cancelled),
                status: "error",
                errorMessage: "cancelled"
            )
        case .protocolError(let errorCode, let errorDescription, let errorDetails, let transactionID):
            return generatePaymentInfo(
                eventType: .status(.failed),
                transactionID: transactionID,
                status: "error",
                errorCode: errorCode,
                errorDescription: errorDescription,
                errorDetails: errorDetails
            )
        case .timedout:
            return generatePaymentInfo(
                eventType: .status(.timeout),
                status: "error",
                errorMessage: "timedout"
            )
        case .runtimeError(let errorCode, let errorMessage):
            return generatePaymentInfo(
                eventType: .status(.failed),
                status: "error",
                errorCode: errorCode,
                errorMessage: errorMessage
            )
        }
    }

    /// Helper method used mainly to reduce the LoC count thanks to default `nil` values
    private func generatePaymentInfo(
        eventType: EventType,
        transactionID: String? = nil,
        status: String?,
        errorCode: String? = nil,
        errorDescription: String? = nil,
        errorDetails: String? = nil,
        errorMessage: String? = nil
    ) -> (ThreeDS2PaymentStatus, EventType) {

        let paymentStatus = ThreeDS2PaymentStatus(
            transactionID: transactionID,
            status: status,
            errorCode: errorCode,
            errorDescription: errorDescription,
            errorDetails: errorDetails,
            errorMessage: errorMessage
        )

        return (paymentStatus, eventType)
    }
}
