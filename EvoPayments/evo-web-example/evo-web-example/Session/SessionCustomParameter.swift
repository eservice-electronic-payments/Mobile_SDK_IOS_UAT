//
//  SessionCustomParameter.swift
//  evo-web-example
//
//  Created by Valentino Urbano on 10/04/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation

struct SessionCustomParameter {
    let parameters: [String: String]

    init(parameters: [String]) {
        var dic: [String: String] = [:]
        for value in parameters.prefix(20) {
            let entries = dic.keys.count + 1
            let key = "CustomParameter\(entries)Or"
            dic[key] = value
        }
        self.parameters = dic
    }

}
