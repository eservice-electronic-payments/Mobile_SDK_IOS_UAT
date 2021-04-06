//
//  EvoStatus+ApplePay.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 04/02/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation
import PassKit

extension Status {
    func toApplePayStatus() -> PKPaymentAuthorizationStatus {
        switch self {
        case .cancelled, .failed, .timeout, .undetermined:
            return .failure
        case .success:
            return .success
        default:
            dLog("toApplePayStatus conversion fail \(self)")
            assertionFailure()
            return .failure
        }
    }

    @available(iOS 11.0, *)
    func toApplePayResult() -> PKPaymentAuthorizationResult {
        let status = toApplePayStatus()
        return PKPaymentAuthorizationResult(status: status, errors: nil)
    }
}
