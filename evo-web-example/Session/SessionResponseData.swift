//
//  SessionResponseData.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 01/08/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

/// Data returned by example token request in SessionProvider
struct SessionResponseData: Codable {
    let mobileCashierUrl: URL
    let merchantId: String
    let token: String
    
    init(data: Data) throws {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(SessionResponseData.self, from: data)
        self = decoded
    }
}
