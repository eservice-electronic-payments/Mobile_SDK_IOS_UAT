//
//  String+turnEmptyToNil.swift
//  evo-web-example
//
//  Created by Adrian Zyga on 25/11/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation

extension String {
    func turnEmptyToNil() -> String? {
        return isEmpty ? nil : self
    }
}
