//
//  EVO.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

/// Turn on to log system events to the console
let evoLoggingEnabled = true

func dLog(_ s: Any) {
    if evoLoggingEnabled {
        print("[EvoPayments] \(s)")
    }
}

/// This is a "namespace" for this library
public enum Evo {}
