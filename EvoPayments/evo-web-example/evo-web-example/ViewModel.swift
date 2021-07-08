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

        let title, value: String
        let kind: Kind

        init(title: String, kind: Kind = .default, value: String = "") {
            self.title = title
            self.kind = kind
            self.value = value
        }
    }

    let actions = [
        Action(title: "AUTH"),
        Action(title: "PURCHASE"),
        Action(title: "VERIFY", kind: .verify)
    ]
    
    let mssUrls = [
        PickerTextFieldItem(title:"Responsive Dev MSS URL", value:"https://merchant-simulator-server-responsivedev.test.intelligent-payments.com/merchant/initializePayment"),
        PickerTextFieldItem(title:"Turnkey QA MSS URL", value:"https://merchant-simulator-server-turnkeyqa.test.intelligent-payments.com/merchant/initializePayment"),
        PickerTextFieldItem(title:"Turnkey UAT MSS URL", value:"https://merchant-simulator-server-turnkeyuat.test.boipapaymentgateway.com/merchant/initializePayment"),
        PickerTextFieldItem(title:"EvoPoland UAT MSS URL", value:"https://merchant-simulator-server-evopolanduat.test.intelligent-payments.com/merchant/initializePayment"),
        PickerTextFieldItem(title:"UniversalPay UAT MSS URL", value:"https://merchant-simulator-server-universalpayuat.test.myriadpayments.com/merchant/initializePayment"),
        PickerTextFieldItem(title:"Turnkey PRE PROD MSS URL", value:"https://merchant-api.secure.eservice.com.pl/merchant/initializePayment"),
        PickerTextFieldItem(title:"Turnkey/EvoPoland PROD MSS URL", value:"https://cashier-api.secure.eservice.com.pl/merchant/initializePayment")
    ]

    var selectedActionIndex: Int?
    var selectedMssUrlIndex: Int?

    /// Obtain a session token from a demo provider
    /// This is an example implementation
    func startSession(withContent content: FormContent,
                      completionHandler: @escaping SessionRequestCompletionHandler) {

        let rawData = prepareSessionData(withContent: content)
        guard case let .success(data) = rawData else {
            if case let .failure(err) = rawData {
                completionHandler(.failure(.provider(err)))
            }
            return
        }
        
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
    
    /// Prepare the session data based on the formContent
    /// - Returns: a Result type when success return the constructed SessionRequestData
    ///          when invalid input was detected, a SessionProvider.Error was raised and further displayed in an alert error message
    private func prepareSessionData(withContent content: FormContent) -> Result<SessionRequestData, SessionProvider.Error> {
        let additionalParameters: [String]?

        if !content.additionalParameters.isEmpty {
            additionalParameters = content.additionalParameters.split(separator: ",").map { String($0) }
        } else {
            additionalParameters = nil
        }

        // sanitise abd validate content.tokenURL
        var sanitisedUrl = content.tokenURL
        sanitisedUrl.removeAll(where: {$0 == " " || $0 == "\n"})
        guard let url = URL(string: sanitisedUrl) else {
            return .failure(.invalidParamTokenUrl(content.tokenURL))
        }
        
        return .success(SessionRequestData(
            tokenUrl: url,
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
        ))
    }
}
