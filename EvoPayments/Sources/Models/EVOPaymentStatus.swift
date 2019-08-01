//
//  EVOPaymentStatus.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

public extension Evo {
    enum PaymentStatus: String {
        case success = "success"
        case cancelled = "cancel"
        case failed = "failure"
        case timeout = "timeout"
        case redirection = "redirection"
        
        public var statusText: String {
            switch self {
            case .success: return "Success!"
            case .cancelled: return "Cancelled"
            case .failed, .timeout, .redirection: return "Oops :("
            }
        }
        
        public var statusDescription: String {
            switch self {
            case .success: return "Your payment was accepted."
            case .cancelled: return "You cancelled the payment."
            case .failed, .redirection: return "We could not process your payment."
            case .timeout: return "Your payment has timed out."
            }
        }
    }
}
