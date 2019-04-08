//
//  IPG.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

func dPrint(_ s: Any) {
    #if DEBUG
    print(s)
    #endif
}

/// All IPG constant structs/enums are extensions to this enum
public enum IPG {
    public typealias SessionToken = String
}

public protocol IPGCompatible {
    associatedtype t
    var ipg: t { get }
}

public extension IPGCompatible {
    public var ipg: IPGExtension<Self> {
        get { return IPGExtension(self) }
    }
}

public struct IPGExtension<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

internal func onMainQueue(_ c: (() -> Void)?) { DispatchQueue.main.async { c?() } }
