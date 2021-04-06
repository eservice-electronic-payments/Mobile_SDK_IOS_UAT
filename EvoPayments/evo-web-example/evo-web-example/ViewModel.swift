//
//  ViewModel.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 10/09/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import Foundation
import EvoPayments

final class ViewModel {
    typealias SessionRequestCompletionHandler = ((Result<Session, SessionRequestError>) -> Void)

    struct Action: PickerTextFieldItemProtocol {
        // swiftlint:disable:next nesting
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

    func generateOrderID(completion: (String) -> Void) {
        let lowercasedAlphanumerics = "abcdefghijklmnopqrstuvwxyz0123456789"
        let randomID = String((0..<10).compactMap { _ in lowercasedAlphanumerics.randomElement() })
        let orderID = "sdk-\(randomID)"
        completion(orderID)
    }

    // MARK: - Private

    /// Apply CustomURL to the session struct if provided
    private func setupSession(
        _ responseSession: Session,
        customCashierURL url: String? = nil
    ) -> Session {
        guard let customURLString = url else {
            // No custom CashierURL provided, ignore
            return responseSession
        }

        if let customURL = URL(string: customURLString) {
            return Session(
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
        let additionalParameters: [String]?

        if !content.additionalParameters.isEmpty {
            additionalParameters = content.additionalParameters.split(separator: ",").map { String($0) }
        } else {
            additionalParameters = nil
        }

        return SessionRequestData(
            tokenUrl: content.tokenURL,
            action: content.action.turnEmptyToNil(),
            customerID: content.customerID,
            customerFirstName: content.customerFirstName.turnEmptyToNil(),
            customerLastName: content.customerLastName.turnEmptyToNil(),
            amount: content.amount,
            currency: content.currency.turnEmptyToNil(),
            country: content.country.turnEmptyToNil(),
            language: content.language.turnEmptyToNil(),
            userDevice: content.userDevice.turnEmptyToNil(),
            customerAddressHouseName: content.customerAddressHouseName.turnEmptyToNil(),
            customerAddressStreet: content.customerAddressStreet.turnEmptyToNil(),
            customerAddressCity: content.customerAddressCity.turnEmptyToNil(),
            customerAddressPostalCode: content.customerAddressPostalCode.turnEmptyToNil(),
            customerAddressCountry: content.customerAddressCountry.turnEmptyToNil(),
            customerAddressState: content.customerAddressState.turnEmptyToNil(),
            customerEmail: content.customerEmail.turnEmptyToNil(),
            customerPhone: content.customerPhone.turnEmptyToNil(),
            orderID: content.orderID,
            additionalParameters: additionalParameters
        )
    }
}
