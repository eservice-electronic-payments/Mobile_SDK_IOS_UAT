//
//  EVOStatus.swift
//  EvoPayments
//
//  Created by Paweł Wojtkowiak on 11/09/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

extension Evo {
    public enum Status: String {
        case success = "success"
        case cancelled = "cancel"
        case failed = "failure"
        case timeout = "timeout"
        case undetermined = "undetermined"
        case started = "paymentStarted"
    }
}
