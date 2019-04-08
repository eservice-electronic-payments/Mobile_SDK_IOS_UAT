//
//  IPGEnvironment.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

public extension IPG {
    public struct Environment {
        public let sessionTokenURL: URL
        public let paymentOperationActionURL: URL
        public let startMobilePaymentURL: URL
        
        public static let production = IPG.Environment(
            sessionTokenURL: URL(string: "https://api.intelligent-payments.com/token")!,
            paymentOperationActionURL: URL(string: "https://api.intelligent-payments.com/payments")!,
            startMobilePaymentURL: URL(string: "https://cashierui-responsivedev.test.myriadpayments.com/react-frontend/index.html")!
        )
        
        public static let userAcceptanceTesting = IPG.Environment(
            sessionTokenURL: URL(string: "https://apiuat.test.intelligent-payments.com/token")!,
            paymentOperationActionURL: URL(string: "https://apiuat.test.intelligent-payments.com/payments")!,
            startMobilePaymentURL: URL(string: "https://cashierui-responsivedev.test.myriadpayments.com/react-frontend/index.html")!
        )
    }
}
