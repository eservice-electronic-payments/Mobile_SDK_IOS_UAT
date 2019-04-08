//
//  URL+.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

internal extension URL {
    func withQueryParameters(_ dict: [String: CustomStringConvertible]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = dict.map { (key, value) in
            return URLQueryItem(name: key, value: "\(value)")
        }
        
        return components?.url
    }
}
