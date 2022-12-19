//
//  PKPaymentNetworkMapper.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 07/02/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation
import PassKit

struct PKPaymentNetworkMapper {
    func network(from string: String) -> PKPaymentNetwork {
        switch string {
        case "CarteBancaire", "CarteBancaires", "CartesBancaires":
            return .cartesBancaires
        default:
//          dLog("Using default Apple initializer for payment network: \(string)")
          return PKPaymentNetwork(string)
        }
    }

    //  Debug only - To be able to initialize from a rawValue each time Apple adds a new card
    //  it needs to be mapped on the server to be able to be passed in to the sdk.
    #if DEBUG
    // swiftlint:disable:next cyclomatic_complexity
    static func debugPrint() {
      print("amex -> \(PKPaymentNetwork.amex.rawValue)")

      print("cartesBancaires -> \(PKPaymentNetwork.cartesBancaires.rawValue)")

      print("chinaUnionPay -> \(PKPaymentNetwork.chinaUnionPay.rawValue)")

      print("discover -> \(PKPaymentNetwork.discover.rawValue)")
      print("eftpos -> \(PKPaymentNetwork.eftpos.rawValue)")
      print("electron -> \(PKPaymentNetwork.electron.rawValue)")

      if #available(iOS 12.1.1, *) {
          print("elo -> \(PKPaymentNetwork.elo.rawValue)")
      }
      print("idCredit -> \(PKPaymentNetwork.idCredit.rawValue)")

      print("interac -> \(PKPaymentNetwork.interac.rawValue)")
      print("JCB -> \(PKPaymentNetwork.JCB.rawValue)")

      if #available(iOS 12.1.1, *) {
          print("mada -> \(PKPaymentNetwork.mada.rawValue)")
      }
      print("maestro -> \(PKPaymentNetwork.maestro.rawValue)")

      print("masterCard -> \(PKPaymentNetwork.masterCard.rawValue)")

      print("privateLabel -> \(PKPaymentNetwork.privateLabel.rawValue)")
      print("quicPay -> \(PKPaymentNetwork.quicPay.rawValue)")
      print("suica -> \(PKPaymentNetwork.suica.rawValue)")

      print("visa -> \(PKPaymentNetwork.visa.rawValue)")
      print("vPay -> \(PKPaymentNetwork.vPay.rawValue)")

   }
    #endif
}
