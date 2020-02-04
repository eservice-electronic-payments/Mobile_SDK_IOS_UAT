//
//  EVOWebView+ApplePay.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 04/02/2020.
//  Copyright © 2020 Paweł Wojtkowiak. All rights reserved.
//

import Foundation
import PassKit

//https://developer.apple.com/library/archive/ApplePay_Guide/Authorization.html#//apple_ref/doc/uid/TP40014764-CH4-SW3

private extension EVOWebView {
        
    func onFinish() {
        applePay.dismissPaymentController()
        
        if !applePay.didAuthorize {
            handleEventType(.status(.cancelled))
        }
    }
    
    func onPaymentAuthorized(payment: PKPayment) {
        sendApplePayResultToJs(token: payment.token.paymentData)
        
        //TODO: Remove
        //MOCK
        applePay.onResultReceived(result: .success)
        //END MOCK
        
        closeOverlay()
    }
}

//MARK: Apple Pay Callbacks

extension EVOWebView: PKPaymentAuthorizationViewControllerDelegate, PKPaymentAuthorizationControllerDelegate {
    
    ///Called in any case - Either Cancelled or Authorized. Because of that we need to keep track of the status of the  transaction and do not cancel it if it got authorized
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        onFinish()
    }

               
    ///Called in any case - Either Cancelled or Authorized. Because of that we need to keep track of the status of the  transaction and do not cancel it if it got authorized
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        onFinish()
    }
                
        ///Transaction Authorized
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                             didAuthorizePayment payment: PKPayment,
                                              completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
       completion(.success)
        fatalError()
       return;
    }

    @available(iOS 11.0, *)
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                             didAuthorizePayment payment: PKPayment,
                                                 handler: @escaping (PKPaymentAuthorizationResult) -> Void) {
        handler(PKPaymentAuthorizationResult(status: .success, errors: nil))
        fatalError()
       return;
    }
}
