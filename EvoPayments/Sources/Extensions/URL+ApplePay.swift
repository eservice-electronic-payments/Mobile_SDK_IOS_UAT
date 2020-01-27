//
//  URL+ApplePay.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 21/01/2020.
//  Copyright © 2020 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

extension URL.Evo {
    func addingSupportedPayments() -> URL? {
        let applePayAvailable = Evo.ApplePay().isAvailable()
        let applePayParameter = ["applePayAvailable": applePayAvailable]
        
        return addingQueryParameters(applePayParameter)
    }
}
