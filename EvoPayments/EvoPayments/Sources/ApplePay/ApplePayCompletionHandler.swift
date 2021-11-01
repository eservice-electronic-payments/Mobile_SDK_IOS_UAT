//
//  ApplePayCompletionHandler.swift
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

class ApplePayCompletionHandler {
    // MARK: Completion handler for different ApplePay result type
    private var completionHandler: Any? = nil
    
    var statusHandler: ApplePayCompletion? {
        get {
            return completionHandler as? ApplePayCompletion
        }
        set {
            completionHandler = newValue
        }
    }
    
    @available(iOS 11.0, *)
    var resultHandler: ApplePayHandler? {
        get {
            return completionHandler as? ApplePayHandler
        }
        set {
            completionHandler = newValue
        }
    }
    
    init(completion: Any) {
        self.completionHandler = completion
    }
    
    ///Convert the result from the server to a result that can be sent back to ApplePay and sends it
    func execute(with result: Status) {
        if #available(iOS 11.0, *),
           let resultHandler = resultHandler {
            resultHandler(result.toApplePayResult())
        } else if let statusHandler = statusHandler {
            statusHandler(result.toApplePayStatus())
        } else {
            dLog("toApplePay Result not available")
        }
    }
}
