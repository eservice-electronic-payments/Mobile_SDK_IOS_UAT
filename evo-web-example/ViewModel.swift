//
//  ViewModel.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 10/09/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation
import EvoPayments

protocol ViewModelDelegate: class {
    func startCashier(withSession session: Evo.Session)
    func showAlert(withErrorMessage errorMessage: String)
}

final class ViewModel {
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
    
    private(set) lazy var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        return formatter
    }()
    
    weak var delegate: ViewModelDelegate?
    
    let actions = [
        Action(title: "AUTH"),
        Action(title: "PURCHASE"),
        Action(title: "VERIFY", kind: .verify)
    ]
    
    var selectedActionIndex: Int?
    
    /// Obtain a session token from a demo provider
    /// This is an example implementation
    func startDemo(withContent content: ViewController.Content) {
        
        let url = "https://cashierui-responsivedev.test.myriadpayments.com/ajax/tokenJson"
        let data = prepareSessionData(
            withTokenURL: url,
            content: content
        )
        
        let provider = SessionProvider()
        provider.requestSession(using: data) { [weak self] result in
            switch result {
            case .success(let session): self?.delegate?.startCashier(withSession: session)
            case .failure(let error): self?.showError(error)
            }
        }
    }
    
    /// Prepare error message to be shown in ViewController's alert
    /// This is an example implementation
    func showError(_ error: SessionProvider.Error) {
        let message: String
        
        switch error {
        case .buildRequestFailed: message = "Could not build session request"
        case .connectionError(let error): message = "Connection error (\(String(describing: error))"
        case .decodingError(let error): message = "Could not decode session (\(String(describing: error))"
        case .invalidStatusCode(let statusCode): message = "Invalid status code \(statusCode)"
        case .responseMissing: message = "Response not received"
        }
        
        delegate?.showAlert(withErrorMessage: message)
    }
    
    // MARK: - Private
    
    private func prepareSessionData(withTokenURL tokenURL: String,
                                    content: ViewController.Content) -> SessionRequestData {
        
        let action = !content.action.isEmpty ? content.action : nil
        let merchantID = content.merchantID
        let merchantPassword = !content.password.isEmpty ? content.password : nil
        let customerID = content.customerID
        let amount = !content.amount.isEmpty ? amountFormatter.number(from: content.amount)?.doubleValue : nil
        let currency = !content.currency.isEmpty ? content.currency : nil
        let country = !content.country.isEmpty ? content.country : nil
        let language = !content.language.isEmpty ? content.language : nil
        
        return SessionRequestData(
            tokenUrl: tokenURL,
            action: action,
            merchantID: merchantID,
            merchantPassword: merchantPassword,
            customerID: customerID,
            amount: amount,
            currency: currency,
            country: country,
            language: language
        )
    }
}
