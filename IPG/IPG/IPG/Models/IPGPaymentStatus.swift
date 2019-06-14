//
//  IPGPaymentStatus.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

public extension IPG {
    enum PaymentStatus: String {
        case success = "success"
        case cancelled = "cancelled"
        case failed = "failed"
        
        public var statusText: String {
            switch self {
            case .success: return "Success!"
            case .cancelled: return "Cancelled"
            case .failed: return "Oops :("
            }
        }
        
        public var statusDescription: String {
            switch self {
            case .success: return "Your payment was accepted."
            case .cancelled: return "You cancelled the payment."
            case .failed: return "We could not process your payment."
            }
        }
    }
}
