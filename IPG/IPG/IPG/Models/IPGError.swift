//
//  IPGError.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

public extension IPG {
    struct SystemError: CustomStringConvertible {
        public let description: String
    }
    
    enum Error: Swift.Error {
        case buildRequestError(String)
        case system(SystemError)
        case responseMissing
        case responseInvalid
        case parsingError(Swift.Error)
        case connection(Swift.Error?)
        case statusCode(Swift.Error?)
        case unknown
    }
}
