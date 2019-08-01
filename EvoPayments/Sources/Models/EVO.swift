//
//  EVO.swift
//  evo-web-example
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

/// This is a "namespace" for this library
public enum Evo {}
