//
//  ApplePayCompletionKind.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 04/02/2020.
//  Copyright © 2020 Paweł Wojtkowiak. All rights reserved.
//

import Foundation
import PassKit

extension Evo {
    @available(iOS 11.0, *)
    typealias ApplePayHandler = ((PKPaymentAuthorizationResult) -> Void)
    
    typealias ApplePayCompletion = ((PKPaymentAuthorizationStatus) -> Void)
    
    enum ApplePayCompletionKind {
        case completion(ApplePayCompletion)
        
        @available(iOS 11.0, *)
        case handler(ApplePayHandler)
        
        ///Convert the result from the server to a result that can be sent back to ApplePay and sends it
        func execute(with result: Evo.Status) {
            switch self {
            case .completion(let applePayStatus):
                applePayStatus(result.toApplePayStatus())
            case .handler(let applePayResult):
                applePayResult(result.toApplePayResult())
            }
        }
        
    }
}
