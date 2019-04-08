//
//  IPGSessionTokenResponseData.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

extension IPG {
    struct SessionTokenResponseData: Codable {
        let result: String
        let resultId: String
        let merchantId: String
        //let additionalDetails: [String: Any]
        let processingTime: Int
        let token: String
    }
}
