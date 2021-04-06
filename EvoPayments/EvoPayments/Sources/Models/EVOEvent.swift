//
//  EVOEvent.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import Foundation

enum EventError: Error {
    case eventKeyNotFound
    case invalidParameters(String)
    case eventNotSupported(String)
}

enum Action {
    case redirection(URL)
    case close
    case applePay(ApplePayRequest)
    case threeDS2ConfigReceived(ThreeDS2Config)
    case start3DS2Challange(ThreeDS2Challange)

    init?(eventName: String, parameters: [String: Any]) throws {
        switch eventName {
        case "redirection":
            guard let urlString = parameters["url"] as? String, let url = URL(string: urlString) else {
                throw EventError.invalidParameters("Redirection URL parameter not found or invalid")
            }
            self = .redirection(url)
        case "close":
            self = .close
        case "processApplePayPayment":
            guard
                let dic = parameters["applePayRequest"] as? [String: Any],
                let request = ApplePayRequest(json: dic)
            else {
                throw EventError.invalidParameters("Apple Pay parameter not found or invalid")
            }
            self = .applePay(request)
        case "getNSoftSdkConfig":
            guard
                let jsonString = parameters["data"] as? String,
                let json = jsonString.data(using: .utf8)
            else {
                throw EventError.invalidParameters("Could not get 3DS2 Config")
            }
            let config = try JSONDecoder().decode(ThreeDS2Config.self, from: json)
            self = .threeDS2ConfigReceived(config)
        case "execute3DS2":
            guard
                let jsonString = parameters["data"] as? String,
                let json = jsonString.data(using: .utf8)
            else {
                throw EventError.invalidParameters("Could not get 3DS2 challenge")
            }
            let challange = try JSONDecoder().decode(ThreeDS2Challange.self, from: json)
            self = .start3DS2Challange(challange)
        default:
            return nil
        }
    }
}

enum EventType {
    case status(Status)
    case action(Action)

    init(from dictionary: [String: Any]) throws {
        guard let eventName = dictionary["event"] as? String else {
            throw EventError.eventKeyNotFound
        }

        if let action = try Action(eventName: eventName, parameters: dictionary) {
            self = .action(action)
        } else if let status = Status(rawValue: eventName) {
            self = .status(status)
        } else {
            throw EventError.eventNotSupported(eventName)
        }
    }
}
