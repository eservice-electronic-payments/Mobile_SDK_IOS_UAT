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
        public let cashierUrl: URL
        public let token: String
        
        public init(cashierUrl: URL, token: String) {
            self.cashierUrl = cashierUrl
            self.token = token
        }
    }
}
