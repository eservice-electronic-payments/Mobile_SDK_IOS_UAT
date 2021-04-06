//
//  EVOConstants.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 10/02/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation

enum Constants {
    static let platform = "IOS"
    static let supported3DS2 = "1"
    static let threeDSV2GUIConfig = ["ShowWhiteBoxInProcessingScreen": "true"]
    #if DEBUG
    static let threeDSV2ClientConfig = ["LogLevel=3", "MaskSensitive=false"]
    #else
    static let threeDSV2ClientConfig = ["LogLevel=0", "MaskSensitive=true"]
    #endif
}
