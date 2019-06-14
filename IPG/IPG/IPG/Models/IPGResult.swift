//
//  IPGResult.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

public extension IPG {
    enum Result<T> {
        case success(T)
        case error(IPG.Error)
    }
}
