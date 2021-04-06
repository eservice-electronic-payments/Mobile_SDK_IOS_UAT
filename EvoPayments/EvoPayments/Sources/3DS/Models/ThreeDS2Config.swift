//
//  ThreeDS2Config.swift
//  EvoPayments
//
//  Created by Adrian Zyga on 18/09/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

/// Structure fetched from the webview containing data needed to create a `Verification3DServiceData` instance
struct ThreeDS2Config: Decodable {
    let dsCa: String
    let dsCert: String
    let dsId: String
    let licenseKey: String
    let messageVersion: String

    private enum CodingKeys: String, CodingKey {
        case dsCa = "rootDsCa"
        case dsCert = "dsCert"
        case dsId = "dsId"
        case licenseKey = "licenseKeyIOS"
        case messageVersion = "messageVersion"
    }
}
