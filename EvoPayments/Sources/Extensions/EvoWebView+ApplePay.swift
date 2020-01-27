//
//  EvoWebView+ApplePay.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 16/01/2020.
//  Copyright © 2020 Paweł Wojtkowiak. All rights reserved.
//

import Foundation
import PassKit //https://developer.apple.com/library/archive/ApplePay_Guide/Authorization.html#//apple_ref/doc/uid/TP40014764-CH4-SW3

extension EVOWebView: PKPaymentAuthorizationViewControllerDelegate {
    ///Cancelled
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        closeOverlay()
        handleEventType(.status(.cancelled))
    }
    
    ///Authorized
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        //TODO: Call JS function with PKPayment.token
        
        //        let jsString = "action.applepay.result(true,KEY)"
        //        webView?.evaluateJavaScript('\(jsString)', completionHandler: nil)
        //        webview?.evaluateJavaScript("addPerson('\(name)', \(age))", completionHandler: nil)
    }

}
