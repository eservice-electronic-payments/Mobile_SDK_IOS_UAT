//
//  EVOSession.swift
//  EVO
//
//  Created by Paweł Wojtkowiak on 14/06/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import Foundation

public struct Session {
    public let mobileCashierUrl: URL
    public let token: String
    public let merchantId: String

    ///  Automatically populated by SDK
    public let platform: String
    public let supported3DS2: String

    public init(mobileCashierUrl: URL, token: String, merchantId: String) {
        self.mobileCashierUrl = mobileCashierUrl
        self.token = token
        self.merchantId = merchantId
        self.platform = Constants.platform
        self.supported3DS2 = Constants.supported3DS2
    }
}
