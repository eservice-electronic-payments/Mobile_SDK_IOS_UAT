//
//  URL+.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import Foundation

public extension URL {
    struct Evo {
        // swiftlint:disable:next nesting
        public typealias QueryParameters = [String: CustomStringConvertible]

        fileprivate let url: URL

        public func addingQueryParameters(_ dict: QueryParameters) -> URL? {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let addedQueryItems: [URLQueryItem] = dict.map { (key, value) in
                return URLQueryItem(name: key, value: "\(value)")
            }

            if components?.queryItems != nil {
                components?.queryItems?.append(contentsOf: addedQueryItems)
            } else {
                components?.queryItems = addedQueryItems
            }

            return components?.url
        }
    }

    var evo: Evo { return Evo(url: self) }
}
