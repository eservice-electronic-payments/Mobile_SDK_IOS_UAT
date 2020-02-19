//
//  ViewModel.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 10/09/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation
import EvoPayments

final class ViewModel {
    typealias SessionRequestCompletionHandler = ((Result<Evo.Session, SessionRequestError>) -> Void)
    
    struct Action: PickerTextFieldItemProtocol {
        enum Kind {
            case verify
            case `default`
        }
        
        let title: String
        let kind: Kind
        
        init(title: String, kind: Kind = .default) {
            self.title = title
            self.kind = kind
        }
    }
    
    let actions = [
        Action(title: "AUTH"),
        Action(title: "PURCHASE"),
        Action(title: "VERIFY", kind: .verify)
    ]
    
    var selectedActionIndex: Int?
    
    /// Obtain a session token from a demo provider
    /// This is an example implementation
    func startSession(withContent content: FormContent,
                      completionHandler: @escaping SessionRequestCompletionHandler) {
        
        let data = prepareSessionData(withContent: content)
        let customCashierURL: String? = content.mobileCashierURL.isEmpty ? nil : content.mobileCashierURL
        
        let provider = SessionProvider()
        provider.requestSession(using: data) { [weak self] result in
            guard let sself = self else {
                completionHandler(.failure(.unknown))
                return
            }
            
            switch result {
            case .success(let responseSession):
                let session = sself.setupSession(responseSession, customCashierURL: customCashierURL)
                completionHandler(.success(session))
            case .failure(let error):
                print("Network Error: \(error.localizedDescription)")
                completionHandler(.failure(.provider(error)))
            }
        }
    }
    
    // MARK: - Private
    
    /// Apply CustomURL to the session struct if provided
    private func setupSession(_ responseSession: Evo.Session,
                              customCashierURL url: String? = nil) -> Evo.Session {
        guard let customURLString = url else {
            // No custom CashierURL provided, ignore
            return responseSession
        }
        
        if let customURL = URL(string: customURLString) {
            return Evo.Session(
                mobileCashierUrl: customURL,
                token: responseSession.token,
                merchantId: responseSession.merchantId
            )
        } else {
            print("♦️ Invalid Cashier URL: \(customURLString). Using default CashierURL.")
            return responseSession
        }
    }
    
    private func prepareSessionData(withContent content: FormContent) -> SessionRequestData {
        let action = !content.action.isEmpty ? content.action : nil
        let customerID = content.customerID
        let customerFirstName = !content.customerFirstName.isEmpty ? content.customerFirstName : nil
        let customerLastName = !content.customerLastName.isEmpty ? content.customerLastName : nil
        let amount = content.amount
        let currency = !content.currency.isEmpty ? content.currency : nil
        let country = !content.country.isEmpty ? content.country : nil
        let language = !content.language.isEmpty ? content.language : nil
        
        return SessionRequestData(
            tokenUrl: content.tokenURL,
            action: action,
            customerID: customerID,
            customerFirstName: customerFirstName,
            customerLastName: customerLastName,
            amount: amount,
            currency: currency,
            country: country,
            language: language
        )
    }
}
