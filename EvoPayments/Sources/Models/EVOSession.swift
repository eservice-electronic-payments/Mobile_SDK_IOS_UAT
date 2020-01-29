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
        public let mobileCashierUrl: URL
        public let token: String
        
        public init(mobileCashierUrl: URL, token: String) {
            self.mobileCashierUrl = mobileCashierUrl
            self.token = token
        }
    }
}
