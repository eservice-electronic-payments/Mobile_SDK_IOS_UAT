//
//  IPGMode.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

extension IPG {
    public enum Mode {
        case online(IPG.Environment)
        case offlineDemo
        
        public static let production = Mode.online(.production)
        public static let userAcceptanceTesting = Mode.online(.userAcceptanceTesting)
    }
}
