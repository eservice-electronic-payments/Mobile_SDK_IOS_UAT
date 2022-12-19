//
//  EVOWebView.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
import ipworks3ds_sdk

/// A WKWebView wrapper that handled EvoPayments callbacks out of the box
open class EVOWebView: UIView {
    public typealias StatusCallback = ((Status) -> Void)

    private(set) var webView: WKWebView?
    private var overlayWindow: UIWindow?

    private var statusCallback: StatusCallback?
    private var session: Session?

    //  Needs to be internal due to being accessed from an extension
    lazy var applePay = ApplePay()
    var threeDS2VerificationService: ThreeDS2VerificationServiceProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Make sure to start from main thread
    open func start(session: Session,
                    statusCallback: @escaping StatusCallback) {
        setupWebView()

        self.session = session
        self.statusCallback = statusCallback

        let queryParams: [String: String] = [
            "token": session.token,
            "merchantId": session.merchantId,
            "platform": session.platform,
            "supported3DS2": session.supported3DS2
        ]

        load(url: session.mobileCashierUrl, queryParameters: queryParams)
    }

    // MARK: Private

    private let messageHandlerName = "JSInterface"

    private func load(url cashierURL: URL, queryParameters: URL.Evo.QueryParameters?) {
        let url: URL
        if let queryParameters = queryParameters {
            url = cashierURL.evo.addingQueryParameters(queryParameters) ?? cashierURL
        } else {
            url = cashierURL
        }
        let applePayUrl = url.evo.addingSupportedPayments(isApplePayAvailable: applePay.isAvailable())

        webView?.load(URLRequest(url: applePayUrl ?? url))
    }

    private func setupWebView() {
        webView?.removeFromSuperview()

        let contentController = WKUserContentController()
        contentController.add(self, name: messageHandlerName)

        let config = WKWebViewConfiguration()
        config.userContentController = contentController
//        if #available(iOS 14.0, *) {
//            config.limitsNavigationsToAppBoundDomains = true
//        }

        let webView = WKWebView(frame: bounds, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        self.webView = webView
    }
}

extension EVOWebView: WKScriptMessageHandler {
    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard message.name == messageHandlerName else { return }

        dLog("Received JS notification: \(message.body)")

        guard let body = message.body as? [String: Any] else {
            dLog("Error: Notification expected to be a dictionary")
            return
        }

        do {
            let eventType = try EventType(from: body)
            handleEventType(eventType)
        } catch {
            callStatus(.failed)
            dLog("An error has occurred: \(error), event: \"\(body)\"")
        }
    }

    internal func handleEventType(_ eventType: EventType) {
        switch eventType {
        case .action(let action):
            switch action {
            case .redirection(let url):
                openSafari(at: url)
                dLog("Redirecting to \(url)")
            case .close:
                closeOverlay()
            case .applePay(let request):
                processApplePayPayment(with: request)
            case .threeDS2ConfigReceived(let config):
                initialize3DS2Service(using: config)
                continuePayment()
            case .start3DS2Challenge(let challenge):
                start(challenge: challenge)
            }
        case .status(let status):
            closeOverlay()
            callStatus(status)
            dLog("Received status: \(status)")
        }
    }

    internal func invokeJS(functionName: String, withData data: Encodable, shouldPassDataAsAString: Bool) {
        do {
            let dataString = try data.convertToJSONString()
            let script = shouldPassDataAsAString ? "\(functionName)('\(dataString)')" : "\(functionName)(\(dataString))"
            DispatchQueue.main.async { [weak self] in
                self?.webView?.evaluateJavaScript(script)
            }

        } catch {
            dLog("Error encoding data: \(error)")
            handleEventType(.status(.failed))
        }
    }

    private func callStatus(_ status: Status) {
        //  We need to call on result received each time since apple pay requires us to give it back the result.
        //  If no apple pay transaction is taking place this has no effects.
        applePay.onResultReceived(result: status)

        DispatchQueue.main.async {
            self.statusCallback?(status)
        }
    }

    private func getOverlayWindow() -> UIWindow? {
        closeOverlay()

        if #available(iOS 13.0, *), let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            overlayWindow = UIWindow(windowScene: scene)
        } else {
            overlayWindow = UIWindow(frame: UIScreen.main.bounds)
        }

        overlayWindow?.windowLevel = .statusBar + 1

        return overlayWindow
    }

    private func openSafari(at url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        // a navigationController is needed for the safariView hireachy
        showOnOverlay(viewController: safariViewController, isNavControllerNeeded: true)
    }

    internal func closeOverlay() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }

    private func showOnOverlay(viewController: UIViewController, isNavControllerNeeded: Bool = false) {
        guard let overlayWindow = getOverlayWindow() else {
            dLog("Safari Window nil")
            assertionFailure()
            return
        }
        let navController = UINavigationController(rootViewController: viewController)
        navController.isNavigationBarHidden = true
        overlayWindow.rootViewController = isNavControllerNeeded ? navController : viewController
        overlayWindow.makeKeyAndVisible()
    }

    private func showAsTopmostController(_ viewController: UIViewController) {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller
            topController.present(viewController, animated: true, completion: nil)
        } else {
            dLog("Topmost Controller for Apple Pay nil")
        }
    }

    // MARK: Apple Pay Request

    ///  Function called to initiate Apple Pay transaction
    private func processApplePayPayment(with request: ApplePayRequest) {
        //  Reset Apple Pay class
        self.applePay = ApplePay()

        //  We have a valid session
        guard let session = session else {
            dLog("Session nil")
            handleEventType(.status(.failed))
            return
        }
        //  Apple Pay is enabled and available on this device
        guard applePay.isAvailable() else {
            dLog("Apple Pay not available")
            handleEventType(.status(.failed))
            return
        }
        //  The User has a valid card for the merchant's supported network and capabilities
        guard applePay.hasAddedCard(for: request.networks, with: request.capabilities) else {
            //  Prompt to add a valid card
            applePay.setupCard()
            return
        }

        //  Convert response object to valid PKPaymentRequest
        let paymentRequest = applePay.setupTransaction(session: session, request: request)

        //  Show native Apple Pay screen with configured PKPaymentRequest object
        guard let viewController = applePay.getApplePayController(request: paymentRequest) else {
            dLog("Error instantiating Apple Pay screen")
            handleEventType(.status(.failed))
            return
        }
        viewController.delegate = self

        assert(applePay.applePayDidAuthorize == false)
        assert(viewController.delegate != nil)

        //  disable swipe to dismiss
        if #available(iOS 13.0, *) {
            viewController.isModalInPresentation = true
        }

        showAsTopmostController(viewController)
    }

    // MARK: 3DS2 Verification

    private func initialize3DS2Service(using config: ThreeDS2Config) {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            let verificationData = Verification3DServiceData(
                RID: config.dsId,
                publicKey: config.dsCert,
                CA: config.dsCa,
                clientConfigs: Constants.threeDSV2ClientConfig,
                runtimeLicense: String(config.licenseKey.reversed()),
                configParameters: Constants.threeDSV2GUIConfig,
                directoryServerID: config.dsId,
                messageVersion: config.messageVersion
            )

            threeDS2VerificationService = ThreeDS2VerificationService(
                verificationData: verificationData,
                transactionBuilder: ThreeDS2Service(),
                viewControler: topController
            )
        } else {
            dLog("Topmost Controller for 3DS2 is nil")
        }
    }

    /**
     * Each credit card payment attempt needs to be created through `threeDS2VerificationService`
     * even if it does not use 3DSV2 verification method, because `threeDS2VerificationService`
     * determines whetever 3DSV2 is needed.
     */
    private func continuePayment() {
        guard
            let threeDS2VerificationService = threeDS2VerificationService
        else {
            dLog("threeDS2VerificationService is nil")
            handleEventType(.status(.failed))
            return
        }

        do {
            let data = try threeDS2VerificationService.generateRequest()
            invokeJS(
                functionName: "continuePayment",
                withData: data,
                shouldPassDataAsAString: true
            )
        } catch {
            dLog("Error while creating request: \(error.localizedDescription)")
            handleEventType(.status(.failed))
        }
    }

    private func start(challenge: ThreeDS2Challenge) {
        guard let threeDS2VerificationService = threeDS2VerificationService else {
            dLog("threeDS2VerificationService is nil")
            handleEventType(.status(.failed))
            return
        }

        threeDS2VerificationService.startChallenge(challenge, timeout: 30) { [weak self] result in
            switch result {
            case .success(let paymentStatus):
                self?.finalizePayment(paymentStatus: paymentStatus)
            case .failure(let error):
                self?.handleChallengeError(error)
            }
        }
    }

    private func handleChallengeError(_ error: Error) {
        dLog("Error with a challenge: \(error)")
        let payload = ThreeDS2PaymentStatus(transactionID: "", status: "",
                                            errorCode: "", errorDescription: "", errorDetails: "", errorMessage: "")
        finalizePayment(paymentStatus: payload)
        let threeDS2Error = error as? ThreeDS2Error ?? .unknown(error)
        let paymentInfo = threeDS2Error.paymentInfo
        handleEventType(paymentInfo.eventType)
    }

    private func finalizePayment(paymentStatus: ThreeDS2PaymentStatus) {
        invokeJS(functionName: "finalize3DS2Payment", withData: paymentStatus, shouldPassDataAsAString: false)
    }
}

// MARK: Redirection

extension EVOWebView: SFSafariViewControllerDelegate {
    ///  User pressed done button, cancel transaction
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        closeOverlay()
        handleEventType(.status(.cancelled))
    }
}
