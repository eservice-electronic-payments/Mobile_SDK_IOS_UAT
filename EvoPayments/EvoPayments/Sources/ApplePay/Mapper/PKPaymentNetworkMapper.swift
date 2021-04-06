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
            //Apple has used different namings in different OS versions. Map to the valid name for the current OS.
            if #available(iOS 11.2, *) {
               return .cartesBancaires
            } else if #available(iOS 11.0, *) {
                return .carteBancaires
            } else if #available(iOS 10.3, *) {
                return .carteBancaire
            } else {
                //Use default initializer
                fallthrough
            }
        default:
//          dLog("Using default Apple initializer for payment network: \(string)")
          return PKPaymentNetwork(string)
        }
    }

    //Debug only - To be able to initialize from a rawValue each time Apple adds a new card
    //it needs to be mapped on the server to be able to be passed in to the sdk.
    #if DEBUG
    // swiftlint:disable:next cyclomatic_complexity
    static func debugPrint() {
      print("amex -> \(PKPaymentNetwork.amex.rawValue)")

      //Deprecated
      if #available(iOS 10.3, *) {
          print("carteBancaire -> \(PKPaymentNetwork.carteBancaire.rawValue)")
      }

      //Deprecated
      if #available(iOS 11.0, *) {
          print("carteBancaires -> \(PKPaymentNetwork.carteBancaires.rawValue)")
      }

      if #available(iOS 11.2, *) {
          print("cartesBancaires -> \(PKPaymentNetwork.cartesBancaires.rawValue)")
      }

      print("chinaUnionPay -> \(PKPaymentNetwork.chinaUnionPay.rawValue)")

      print("discover -> \(PKPaymentNetwork.discover.rawValue)")

      if #available(iOS 12.0, *) {
          print("eftpos -> \(PKPaymentNetwork.eftpos.rawValue)")
      }

      if #available(iOS 12.0, *) {
          print("electron -> \(PKPaymentNetwork.electron.rawValue)")
      }

      if #available(iOS 12.1.1, *) {
          print("elo -> \(PKPaymentNetwork.elo.rawValue)")
      }

      if #available(iOS 10.3, *) {
          print("idCredit -> \(PKPaymentNetwork.idCredit.rawValue)")
      }

      print("interac -> \(PKPaymentNetwork.interac.rawValue)")

      if #available(iOS 10.1, *) {
          print("JCB -> \(PKPaymentNetwork.JCB.rawValue)")
      }

      if #available(iOS 12.1.1, *) {
          print("mada -> \(PKPaymentNetwork.mada.rawValue)")
      }

      if #available(iOS 12.0, *) {
          print("maestro -> \(PKPaymentNetwork.maestro.rawValue)")
      }

      print("masterCard -> \(PKPaymentNetwork.masterCard.rawValue)")

      print("privateLabel -> \(PKPaymentNetwork.privateLabel.rawValue)")

      if #available(iOS 10.3, *) {
          print("quicPay -> \(PKPaymentNetwork.quicPay.rawValue)")
      }

      if #available(iOS 10.1, *) {
          print("suica -> \(PKPaymentNetwork.suica.rawValue)")
      }

      print("visa -> \(PKPaymentNetwork.visa.rawValue)")

      if #available(iOS 12.0, *) {
          print("vPay -> \(PKPaymentNetwork.vPay.rawValue)")
      }

   }
    #endif
}
