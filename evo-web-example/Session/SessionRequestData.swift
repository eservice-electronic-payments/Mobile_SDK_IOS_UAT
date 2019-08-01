//
//  SessionRequestData.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

struct SessionRequestData {
    let tokenUrl: URL
    let merchantId: String
    let customerId: String
    
    init(tokenUrl: String, merchantId: String, customerId: String) {
        self.tokenUrl = URL(string: tokenUrl)!
        self.merchantId = merchantId
        self.customerId = customerId
    }
}
