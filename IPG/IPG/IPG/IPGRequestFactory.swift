//
//  IPGRequestFactory.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

final class IPGRequestFactory {
    
    let environment: IPG.Environment
    
    init(environment: IPG.Environment) {
        self.environment = environment
    }
    
    func sessionTokenRequest(parameters: [String: CustomStringConvertible]) -> URLRequest? {
        guard let url = environment.sessionTokenURL.withQueryParameters(parameters) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }
}
