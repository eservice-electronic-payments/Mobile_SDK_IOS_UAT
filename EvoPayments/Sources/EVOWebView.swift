//
//  EVOWebView.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

/// A WKWebView wrapper that handled EvoPayments callbacks out of the box
open class EVOWebView: UIView {
    public typealias StatusCallback = ((Evo.Status) -> Void)
    
    private(set) var webView: WKWebView?
    private var overlayWindow: UIWindow?
    
    private var statusCallback: StatusCallback?
    private var session: Evo.Session?
    
    private var applePayDidAuthorize = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Make sure to start from main thread
    open func start(session: Evo.Session,
                    statusCallback: @escaping StatusCallback) {
        setupWebView()
        
        self.session = session
        self.statusCallback = statusCallback
        self.applePayDidAuthorize = false
        
        let queryParams: [String: String] = [
            "token": session.token,
            "merchantId": session.merchantId
        ]
        
        load(url: session.cashierUrl, queryParameters: queryParams)
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
        let applePayUrl = url.evo.addingSupportedPayments()
        
        webView?.load(URLRequest(url: applePayUrl ?? url))
    }
    
    private func setupWebView() {
        webView?.removeFromSuperview()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: messageHandlerName)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let wv = WKWebView(frame: bounds, configuration: config)
        wv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wv)
        wv.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        wv.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        wv.topAnchor.constraint(equalTo: topAnchor).isActive = true
        wv.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        self.webView = wv
    }
}

extension EVOWebView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == messageHandlerName else { return }
        
        dLog("Received JS notification: \(message.body)")
        
        guard let body = message.body as? [String: Any] else {
            dLog("Error: Notification expected to be a dictionary")
            return
        }
        
        do {
            let eventType = try Evo.EventType(from: body)
            handleEventType(eventType)
        } catch {
            callStatus(.failed)
            dLog("An error has occurred: \(error), event: \"\(body)\"")
        }
    }
    
    internal func handleEventType(_ eventType: Evo.EventType) {
        switch eventType {
        case .action(let action):
            switch action {
            case .redirection(let url):
                openSafari(at: url)
                dLog("Redirecting to \(url)")
//                dLog("Saari Window Visible After redirect: \(overlayWindow?.isKeyWindow)")
            case .close:
                closeOverlay()
                break
            }
        case .status(let status):
            closeOverlay()
            
            callStatus(status)
            dLog("Received status: \(status)")
        }
    }
    
    private func callStatus(_ status: Evo.Status) {
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
        let safari = SFSafariViewController(url: url)
        safari.delegate = self
        
        showVcOnOverlay(vc: safari)
//        dLog("Safari Window Frame: \(overlayWindow.frame)")
//        dLog("Safari Window Visible: \(overlayWindow.isKeyWindow)")
    }
    
    internal func closeOverlay() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }
    
    
    private func showVcOnOverlay(vc: UIViewController) {
        guard let overlayWindow = getOverlayWindow() else {
             dLog("Safari Window nil")
             assertionFailure()
             return
         }
        
         overlayWindow.rootViewController = vc
         overlayWindow.makeKeyAndVisible()
    }
    
    //MARK: Apple Pay
    
    public func presentApplePay(with request: Evo.ApplePayRequest) {
        self.applePayDidAuthorize = false
        
        let applePay = Evo.ApplePay()
        guard let session = session else {
            dLog("Session nil")
            handleEventType(.status(.failed))
            return
        }
        guard applePay.isAvailable() else {
            dLog("Apple Pay not available")
            handleEventType(.status(.failed))
            return
        }
        
        let paymentRequest = applePay.setupTransaction(session: session, request: request)
        guard let vc = applePay.getApplePayController(request: paymentRequest) else {
            dLog("Error instantiating Apple Pay screen")
            handleEventType(.status(.failed))
            return
        }
        vc.delegate = self
        showVcOnOverlay(vc: vc)
    }
    
    private func sendResultToJs(token: Data) {
        //https://developer.apple.com/library/archive/documentation/PassKit/Reference/PaymentTokenJSON/PaymentTokenJSON.html
        guard let tokenString = String(data: token, encoding: .utf8) else {
            dLog("Error converting Apple Pay token")
            handleEventType(.status(.failed))
            return
        }
        webView?.evaluateJavaScript("applePayResult('\(tokenString)')", completionHandler: nil)
    }

}

extension EVOWebView: SFSafariViewControllerDelegate {
    ///User pressed done button, cancel transaction
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        closeOverlay()
        handleEventType(.status(.cancelled))
    }
}

//MARK: Apple Pay

import PassKit //https://developer.apple.com/library/archive/ApplePay_Guide/Authorization.html#//apple_ref/doc/uid/TP40014764-CH4-SW3

extension EVOWebView: PKPaymentAuthorizationViewControllerDelegate {
        
    ///Called in any case - Either Cancelled or Authorized
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        closeOverlay()
        
        if !applePayDidAuthorize {
            handleEventType(.status(.cancelled))
        }
    }
    
    ///Authorized
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        applePayDidAuthorize = true
        sendResultToJs(token: payment.token.paymentData)
    }

}
