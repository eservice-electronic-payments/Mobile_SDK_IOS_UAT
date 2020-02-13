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

    //MARK: Payment
    
    ///Expose Apple Pay transaction result to JS
    func sendApplePayResultToJs(token: Data) {
        //https://developer.apple.com/library/archive/documentation/PassKit/Reference/PaymentTokenJSON/PaymentTokenJSON.html
        
        //Decode token to Base64 string (UTF8)
        let tokenString = token.base64EncodedString()
        
        //Call back javascript with transaction result
        webView?.evaluateJavaScript("onApplePayTokenReceived('\(tokenString)')", completionHandler: nil)
    }
    
    //MARK: Callbacks from Apple Pay
        
    func onFinish() {
        applePay.dismissPaymentController()
        
        if !applePay.applePayDidAuthorize {
            handleEventType(.status(.cancelled))
        }
    }
    
    func onPaymentAuthorized(payment: PKPayment, handler: Evo.ApplePayCompletionKind) {
        applePay.applePayAuthorized(callback: handler)
        
        
        sendApplePayResultToJs(token: payment.token.paymentData)
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
        onPaymentAuthorized(payment: payment, handler: .completion(completion))
    }

    @available(iOS 11.0, *)
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                             didAuthorizePayment payment: PKPayment,
                                                 handler: @escaping (PKPaymentAuthorizationResult) -> Void) {
        onPaymentAuthorized(payment: payment, handler: .handler(handler))
    }
}
