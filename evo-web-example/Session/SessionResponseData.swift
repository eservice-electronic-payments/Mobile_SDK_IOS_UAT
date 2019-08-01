//
//  SessionResponseData.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 01/08/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

struct SessionResponseData: Codable {
    let merchantId: String
    let cashierUrl: URL
    let token: String
    
    init(data: Data) throws {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(SessionResponseData.self, from: data)
        self = decoded
    }
}
