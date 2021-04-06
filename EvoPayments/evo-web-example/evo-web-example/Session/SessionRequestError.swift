//
//  SessionRequestError.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 11/09/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import Foundation
import EvoPayments

enum SessionRequestError: Error {
    case provider(SessionProvider.Error)
    case unknown

    var debugMessage: String {
        let message: String

        switch self {
        case .provider(let providerError):
            switch providerError {
            case .buildRequestFailed: message = "Could not build session request"
            case .connectionError(let error): message = "Connection error (\(error.localizedDescription))"
            case .decodingError(let error): message = "Could not decode session (\(error.localizedDescription))"
            case .invalidStatusCode(let statusCode): message = "Invalid status code \(statusCode)"
            case .responseMissing: message = "Response not received"
            case .dataMissing: message = "Response data not received"
            }
        case .unknown:
            message = "An error has occurred"
        }

        return message
    }

    var errorMessage: String {
        return "Failed starting payment process. Debug message: \(debugMessage)"
    }

}
