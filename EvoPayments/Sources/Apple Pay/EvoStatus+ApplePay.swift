//
//  EvoStatus+ApplePay.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 04/02/2020.
//  Copyright © 2020 Paweł Wojtkowiak. All rights reserved.
//

import Foundation
import PassKit

extension Evo.Status {
    func toApplePayStatus() -> PKPaymentAuthorizationStatus {
        switch self {
        case .cancelled, .failed, .timeout:
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
