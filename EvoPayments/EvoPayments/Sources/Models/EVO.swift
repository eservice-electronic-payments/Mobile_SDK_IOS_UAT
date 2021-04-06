//
//  EVO.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import Foundation

#if DEBUG
/// Turn on to log system events to the console
let evoLoggingEnabled = true
#else
let evoLoggingEnabled = false
#endif

func dLog(_ instance: Any) {
    if evoLoggingEnabled {
        print("[EvoPayments] \(instance)")
    }
}
