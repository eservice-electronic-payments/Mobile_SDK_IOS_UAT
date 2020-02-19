//
//  EVOEvent.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

internal extension Evo {
    enum EventError: Error {
        case eventKeyNotFound
        case invalidParameters(String)
        case eventNotSupported(String)
    }
    
    enum Action {
        case redirection(URL)
        case close
        
        init?(eventName: String, parameters: [String: Any]) throws {
            switch eventName {
            case "redirection":
                if let urlString = parameters["url"] as? String, let url = URL(string: urlString) {
                    self = .redirection(url)
                } else {
                    throw EventError.invalidParameters("Redirection URL parameter not found or invalid")
                }
            case "close":
                self = .close
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
}
