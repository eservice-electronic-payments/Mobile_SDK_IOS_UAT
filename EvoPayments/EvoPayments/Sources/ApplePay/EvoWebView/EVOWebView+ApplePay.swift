//
//  EVOWebView+ApplePay.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 04/02/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation
import PassKit

//https://developer.apple.com/library/archive/ApplePay_Guide/Authorization.html#//apple_ref/doc/uid/TP40014764-CH4-SW3

private extension EVOWebView {

    // MARK: Payment

    ///Expose Apple Pay transaction result to JS
    func sendApplePayResultToJs(token: PKPaymentToken) {
        // swiftlint:disable:next line_length
        //https://developer.apple.com/library/archive/documentation/PassKit/Reference/PaymentTokenJSON/PaymentTokenJSON.html
        invokeJS(functionName: "onApplePayTokenReceived", withData: token, shouldPassDataAsAString: true)
    }

    // MARK: Callbacks from Apple Pay

    func onFinish() {
        applePay.dismissPaymentController()

        if !applePay.applePayDidAuthorize {
            handleEventType(.status(.cancelled))
        }
    }

    func onPaymentAuthorized(payment: PKPayment, handler: ApplePayCompletionHandler) {
        applePay.applePayAuthorized(callback: handler)

        sendApplePayResultToJs(token: payment.token)
    }

}

// MARK: Apple Pay Callbacks

extension EVOWebView: PKPaymentAuthorizationViewControllerDelegate, PKPaymentAuthorizationControllerDelegate {

    //Called in any case - Either Cancelled or Authorized.
    //Because of that we need to keep track of the status of the  transaction and do not cancel it if it got authorized
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        onFinish()
    }

    //Called in any case - Either Cancelled or Authorized.
    //Because of that we need to keep track of the status of the  transaction and do not cancel it if it got authorized
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        onFinish()
    }

    ///Transaction Authorized
    public func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        completion: @escaping (PKPaymentAuthorizationStatus) -> Void
    ) {
        onPaymentAuthorized(payment: payment, handler: ApplePayCompletionHandler(completion: completion))
    }

    @available(iOS 11.0, *)
    public func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        onPaymentAuthorized(payment: payment, handler: ApplePayCompletionHandler(completion: handler))
    }
}
