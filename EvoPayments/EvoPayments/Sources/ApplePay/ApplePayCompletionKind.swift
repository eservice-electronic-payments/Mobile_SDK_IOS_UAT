//
//  ApplePayCompletionKind.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 04/02/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation
import PassKit

@available(iOS 11.0, *)
typealias ApplePayHandler = ((PKPaymentAuthorizationResult) -> Void)

typealias ApplePayCompletion = ((PKPaymentAuthorizationStatus) -> Void)

enum ApplePayCompletionKind {
    case completion(ApplePayCompletion)

    @available(iOS 11.0, *)
    case handler(ApplePayHandler)

    ///Convert the result from the server to a result that can be sent back to ApplePay and sends it
    func execute(with result: Status) {
        switch self {
        case .completion(let applePayStatus):
            applePayStatus(result.toApplePayStatus())
        case .handler(let applePayResult):
            if #available(iOS 11.0, *) {
                applePayResult(result.toApplePayResult())
            } else {
                dLog("toApplePayResult not available")
            }
        }
    }
}
