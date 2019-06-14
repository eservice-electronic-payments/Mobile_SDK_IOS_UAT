//
//  IPGEnvironment.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

public extension IPG {
    struct Environment {
        public let sessionTokenURL: URL
        public let paymentOperationActionURL: URL
        public let startMobilePaymentURL: URL
        
        private init(sessionTokenURL: String,
                     paymentOperationActionURL: String,
                     startMobilePaymentURL: String) {
            self.sessionTokenURL = URL(string: sessionTokenURL)!
            self.paymentOperationActionURL = URL(string: paymentOperationActionURL)!
            self.startMobilePaymentURL = URL(string: startMobilePaymentURL)!
        }
        
        public static let production = IPG.Environment(
            sessionTokenURL: "https://api.intelligent-payments.com/token",
            paymentOperationActionURL: "https://api.intelligent-payments.com/payments",
            startMobilePaymentURL: "https://cashierui-responsivedev.test.myriadpayments.com/react-frontend/index.html"
        )
        
        public static let userAcceptanceTesting = IPG.Environment(
            sessionTokenURL: "https://cashierui-responsivedev.test.myriadpayments.com/ajax/token",
            paymentOperationActionURL: "https://apiuat.test.intelligent-payments.com/payments",
            startMobilePaymentURL: "https://cashierui-responsivedev.test.myriadpayments.com/react-frontend/index.html"
        )
    }
}
