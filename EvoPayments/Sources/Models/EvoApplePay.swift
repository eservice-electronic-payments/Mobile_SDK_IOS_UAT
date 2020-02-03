//
//  EvoApplePay.swift
//  EvoPayments
//
//  Created by Valentino Urbano on 16/01/2020.
//  Copyright © 2020 Paweł Wojtkowiak. All rights reserved.
//

import Foundation
import PassKit //https://developer.apple.com/library/archive/ApplePay_Guide/Authorization.html#//apple_ref/doc/uid/TP40014764-CH4-SW3

//Protocol namespacing still not allowed in Swift https://forums.swift.org/t/namespacing-protocols-to-other-types/7328/7
protocol EvoApplePayDelegate: class {
    func onFinish()
    func onPaymentAuthorized(payment: PKPayment)
}

extension Evo {
    struct ApplePayRequest {
        
        ///Init from JSON object from JS
        init?(json: [String:Any]) {
            guard let companyName: String = json["companyName"] as? String else {
                dLog("companapplePay Request yName nil")
                return nil
            }
            self.companyName = companyName

            guard let currencyCode: String = json["currencyCode"] as? String else {
                dLog("currencapplePay Request yCode nil")
                return nil
            }
            self.currencyCode = currencyCode

            guard let countryCode: String = json["countryCode"] as? String else {
                dLog("countrapplePay Request yCode nil")
                return nil
            }
            self.countryCode = countryCode

            guard let merchant: String = json["merchant"] as? String else {
                dLog("merapplePay Request chant nil")
                return nil
            }
            self.merchant = merchant

            guard let price: String = json["price"] as? String else {
                dLog("applePay Request price nil")
                return nil
            }
            self.price = price

            guard let token: String = json["token"] as? String else {
                dLog("applePay Request token nil")
                return nil
            }
            self.token = token
            
            //TODO: Define mapping
            guard let networks: [String] = json["networks"] as? [String] else {
                dLog("applePay Request token nil")
                return nil
            }
            let paymentNetworks = networks.map{ PKPaymentNetwork(rawValue: $0) }
            self.networks = paymentNetworks
            
            //TODO: Define mapping
            guard let capabilities: UInt = json["capabilities"] as? UInt else {
                dLog("applePay Request token nil")
                return nil
            }
            let merchantCapability = PKMerchantCapability(rawValue: capabilities)
            self.capabilities = merchantCapability
            
        }
        
        let companyName: String
        let currencyCode: String
        let countryCode: String
        let merchant: String
        let price: String
        let token: String
        let networks: [PKPaymentNetwork]
        let capabilities: PKMerchantCapability
        
//        #if DEBUG
        private init(companyName: String, currencyCode: String, countryCode: String, merchant: String, price: String, token: String, networks: [PKPaymentNetwork], capabilities: PKMerchantCapability) {
            self.companyName = companyName
            self.currencyCode = currencyCode
            self.countryCode = countryCode
            self.merchant = merchant
            self.price = price
            self.token = token
            self.networks = networks
            self.capabilities = capabilities
        }
        
        static func dummyData() -> Self {
            return ApplePayRequest(companyName: "Test",
                                   currencyCode: "USD",
                                   countryCode: "US",
                                   merchant: "merchant.com.valentinourbano.testApplePay",
                                   price: "10.88",
                                   token: "TOKEN",
                                   networks: [.masterCard,.visa],
                                   capabilities: [.capability3DS, .capabilityCredit, .capabilityDebit])
        }
//        #endif
    }
    
    final public class ApplePay: NSObject, PKPaymentAuthorizationViewControllerDelegate { //Needs to inherit from NSObject to be able to implement delegate methods
        init(delegate: EvoApplePayDelegate) {
            self.delegate = delegate
        }
        
        weak var delegate: EvoApplePayDelegate?
        
        //didFinish callback always gets called so we need to be able to distinguish between a failure and a success state
        private var applePayDidAuthorize = false
        var didAuthorize: Bool { applePayDidAuthorize }
        
        //After we send the result to the server and get the response we need to callback to Apple Pay with the result
        typealias ApplePayCompletion = ((PKPaymentAuthorizationStatus) -> Void)
        private var successCallback: ApplePayCompletion?
        
        private var paymentRequest: PKPaymentRequest?
        
        private weak var applePayViewController: PKPaymentAuthorizationViewController? {
            didSet {
                dLog("Apple Pay Vc \(applePayViewController)")
                dLog("Apple Pay Vc Delegate \(applePayViewController?.delegate)")
            }
        }
        
        //MARK: Setup
        
        ///Is Apple Pay supported
        func isAvailable() -> Bool {
            return PKPaymentAuthorizationViewController.canMakePayments()
        }
        
        ///Does the user have a card with merchant's supported network and capabilities
        func hasAddedCard(for network: [PKPaymentNetwork], with capabilities: PKMerchantCapability) -> Bool {
            return PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: network, capabilities: capabilities)
        }
        
        ///Show form to setup a new card
        func setupCard() {
            PKPassLibrary().openPaymentSetup()
        }
        
        ///Converts Server response into PKPaymentRequest
        func setupTransaction(session: Evo.Session, request: Evo.ApplePayRequest) -> PKPaymentRequest {
            let transaction = PKPaymentRequest()
            transaction.currencyCode = request.currencyCode
            transaction.countryCode = request.countryCode
            transaction.merchantIdentifier = request.merchant
            
            transaction.merchantCapabilities = request.capabilities
            transaction.supportedNetworks = request.networks
            
            transaction.applicationData = Data(base64Encoded: request.token)
            
            if #available(iOS 11.0, *) {
                transaction.requiredShippingContactFields = Set<PKContactField>()
                transaction.requiredBillingContactFields = Set<PKContactField>()
            }

            
            let locale = Locale(identifier: "en_US_POSIX")
            //Decimal from string would not work with numbers having any kind of decimal separator
            //2,333.33 would become 2 even if using en_US_POSIX or en_US locale
            let fixedString = request.price.replacingOccurrences(of: ",", with: "")
            let subtotal = NSDecimalNumber(string: fixedString, locale: locale)
            
            let total = PKPaymentSummaryItem(label: request.companyName, amount: subtotal, type: .final)
            
            transaction.paymentSummaryItems = [total]
            
            self.paymentRequest = transaction
            
            return transaction
        }
        
        ///Sets up and returns Apple PKPaymentAuthorizationViewController for specified transaction request
        func getApplePayController(request: PKPaymentRequest) -> PKPaymentAuthorizationViewController? {
            guard let vc = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                return nil
            }
            
            //Set ourselves as delegate to get callbacks on the transaction status
            vc.delegate = self
            
            //we keep a weak reference to the controller to be able to dismiss it if necessary
            self.applePayViewController = vc
            
            return vc
        }
    
        //MARK: Callback
        
        func onResultReceived(result: Evo.Status) {
            guard didAuthorize else {
                return
            }
            
            successCallback?(result.toApplePayStatus())
        }
        
        //MARK: Internal
        
        private func dismissPaymentController() {
            DispatchQueue.main.async {
                self.applePayViewController?.dismiss(animated: true, completion: { [weak self] in
                    self?.applePayViewController = nil
                    self?.applePayDidAuthorize = false
                })
            }
        }
        
        ////////////

           
            ///Called in any case - Either Cancelled or Authorized. Because of that we need to keep track of the status of the  transaction and do not cancel it if it got authorized
            public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
                fatalError()
                return;
                
                dismissPaymentController()
                delegate?.onFinish()
            }
            
            ///Transaction Authorized
        public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                 didAuthorizePayment payment: PKPayment,
                                                  completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
           completion(.success)
           return;
           
           applePayDidAuthorize = true
           successCallback = completion
           delegate?.onPaymentAuthorized(payment: payment)
        }

        @available(iOS 11.0, *)
        public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                 didAuthorizePayment payment: PKPayment,
                                                     handler: @escaping (PKPaymentAuthorizationResult) -> Void) {
            handler(PKPaymentAuthorizationResult(status: .success, errors: nil))
           return;
           
           applePayDidAuthorize = true
//           successCallback = handler//TODO: 
           delegate?.onPaymentAuthorized(payment: payment)
        }
        
        ///////////

    }
    
}


//MARK: Apple Pay Callbacks
/*
extension Evo.ApplePay: PKPaymentAuthorizationViewControllerDelegate {
        
    ///Called in any case - Either Cancelled or Authorized. Because of that we need to keep track of the status of the  transaction and do not cancel it if it got authorized
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        return;
        
        dismissPaymentController()
        delegate?.onFinish()
    }
    
    ///Transaction Authorized
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(.success)
        return;
        
        applePayDidAuthorize = true
        successCallback = completion
        delegate?.onPaymentAuthorized(payment: payment)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, completion: @escaping (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {
        guard let paymentRequest = self.paymentRequest else {
            fatalError()
        }
        completion(.success, [], paymentRequest.paymentSummaryItems);
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        completion(.success,[])
    }
    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, handler completion: @escaping (PKPaymentRequestShippingContactUpdate) -> Void) {
        guard let paymentRequest = self.paymentRequest else {
            fatalError()
        }
        completion(PKPaymentRequestShippingContactUpdate(paymentSummaryItems: paymentRequest.paymentSummaryItems))
    }
    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect paymentMethod: PKPaymentMethod, handler completion: @escaping (PKPaymentRequestPaymentMethodUpdate) -> Void) {
        guard let paymentRequest = self.paymentRequest else {
            fatalError()
        }
        completion(PKPaymentRequestPaymentMethodUpdate(paymentSummaryItems: paymentRequest.paymentSummaryItems))
    }
}
*/

extension Evo.Status {
    func toApplePayStatus() -> PKPaymentAuthorizationStatus {
        switch self {
        case .cancelled, .failed, .timeout:
            return .failure
        case .success:
            return .success
        default:
            dLog("toApplePayStatus conversion fail \(self)")
            assertionFailure()
            return .failure
        }
    }
}
