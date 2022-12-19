//
//  EvoApplePay.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 16/01/2020.
//  Copyright © 2020 Intelligent Payments. All rights reserved.
//

import Foundation
import PassKit

//https://developer.apple.com/library/archive/ApplePay_Guide/Authorization.html#//apple_ref/doc/uid/TP40014764-CH4-SW3

final class ApplePay {
    //  didFinish callback always gets called
    //  so we need to be able to distinguish between a failure and a success state
    private(set) var applePayDidAuthorize = false

    //  After we send the result to the server and get the response we need to callback to Apple Pay with the result
    private var successCallback: ApplePayCompletionHandler?

    private var paymentRequest: PKPaymentRequest?
    public weak var applePayViewController: PKPaymentAuthorizationViewController?

    // MARK: Setup

    ///  Is Apple Pay supported
    func isAvailable() -> Bool {
        return PKPaymentAuthorizationViewController.canMakePayments()
    }

    ///  Does the user have a card with merchant's supported network and capabilities
    func hasAddedCard(for network: [PKPaymentNetwork], with capabilities: PKMerchantCapability) -> Bool {
        return PKPaymentAuthorizationViewController.canMakePayments(
            usingNetworks: network,
            capabilities: capabilities
        )
    }

    ///  Show form to setup a new card
    func setupCard() {
        PKPassLibrary().openPaymentSetup()
    }

    ///  Converts Server response into PKPaymentRequest
    func setupTransaction(session: Session, request: ApplePayRequest) -> PKPaymentRequest {
        let transaction = PKPaymentRequest()
        transaction.currencyCode = request.currencyCode
        transaction.countryCode = request.countryCode
        transaction.merchantIdentifier = request.merchant

        transaction.merchantCapabilities = request.capabilities
        transaction.supportedNetworks = request.networks

        if #available(iOS 11.0, *) {
            //  Not required
            transaction.requiredShippingContactFields = Set<PKContactField>()
            transaction.requiredBillingContactFields = Set<PKContactField>()
        }

        let locale = Locale(identifier: "en_US_POSIX")
        //  Decimal from string would not work with numbers having any kind of decimal separator
        //  2,333.33 would become 2 even if using en_US_POSIX or en_US locale
        let fixedString = request.price.replacingOccurrences(of: ",", with: "")
        let subtotal = NSDecimalNumber(string: fixedString, locale: locale)

        let total = PKPaymentSummaryItem(label: request.companyName, amount: subtotal, type: .final)

        transaction.paymentSummaryItems = [total]

        self.paymentRequest = transaction

        return transaction
    }

    ///  Sets up and returns Apple PKPaymentAuthorizationViewController for specified transaction request
    func getApplePayController(request: PKPaymentRequest) -> PKPaymentAuthorizationViewController? {
        guard let viewController = PKPaymentAuthorizationViewController(paymentRequest: request) else {
            return nil
        }

        //  we keep a weak reference to the controller to be able to dismiss it if necessary
        self.applePayViewController = viewController

        return viewController
    }

    // MARK: Callback

    //  Success callback from apple pay
    func applePayAuthorized(callback: ApplePayCompletionHandler) {
        applePayDidAuthorize = true
        successCallback = callback
    }

    //  Callback from JS After sendingpayment token
    func onResultReceived(result: Status) {
        guard applePayDidAuthorize else {
            return
        }

        successCallback?.execute(with: result)
    }

    //  Callback after failure, cancellation or finihed transaction
    func dismissPaymentController() {
        DispatchQueue.main.async {
            self.applePayViewController?.dismiss(animated: true, completion: { [weak self] in
                self?.reset()
            })
        }
    }

    // MARK: Private

    private func reset() {
        self.applePayViewController = nil
        self.applePayDidAuthorize = false
        self.successCallback = nil
    }

}
