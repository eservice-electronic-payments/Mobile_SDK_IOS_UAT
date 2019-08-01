//
//  EVOSession.swift
//  EVO
//
//  Created by Paweł Wojtkowiak on 14/06/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

public extension Evo {
    struct Session {
        let cashierUrl: URL
        let token: String
        let merchantId: String
        
        public init(cashierUrl: URL, token: String, merchantId: String) {
            self.cashierUrl = cashierUrl
            self.token = token
            self.merchantId = merchantId
        }
    }
}
