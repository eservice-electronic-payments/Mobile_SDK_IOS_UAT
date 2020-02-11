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
    
    //Needs to be internal due to being accessed from an extension
    var applePay = Evo.ApplePay()
    
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
        
        let queryParams: [String: String] = [
            "token": session.token,
            "merchantId": session.merchantId,
            "platform": session.platform
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
        
        //TODO: Remove
        //TEST
        PKPaymentNetworkMapper.debugPrint()
        processApplePayPayment(with: Evo.ApplePayRequest.dummyData())
        //END TEST
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
//                dLog("Safari Window Visible After redirect: \(overlayWindow?.isKeyWindow)")
            case .close:
                closeOverlay()
            case .applePay(let request):
                processApplePayPayment(with: request)
            }
        case .status(let status):
            closeOverlay()
            
            callStatus(status)
            dLog("Received status: \(status)")
        }
    }
    
    private func callStatus(_ status: Evo.Status) {
        //We need to call on result received each time since apple pay requires us to give it back the result. If no apple pay transaction is taking place this has no effects.
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
    
    private func showAsTopmostController(vc: UIViewController) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller
            topController.present(vc, animated: true, completion: nil)
        } else {
            dLog("Topmost Controller for Apple Pay nil")
        }
    }
    
    //MARK: Apple Pay Request
    
    ///Function called to initiate Apple Pay transaction
    private func processApplePayPayment(with request: Evo.ApplePayRequest) {
        //Reset Apple Pay class
        self.applePay = Evo.ApplePay()
        
        //We have a valid session
        guard let session = session else {
            dLog("Session nil")
            handleEventType(.status(.failed))
            return
        }
        //Apple Pay is enabled and available on this device
        guard applePay.isAvailable() else {
            dLog("Apple Pay not available")
            handleEventType(.status(.failed))
            return
        }
        //The User has a valid card for the merchant's supported network and capabilities
        guard applePay.hasAddedCard(for: request.networks, with: request.capabilities) else {
            //Prompt to add a valid card
            applePay.setupCard()
            return
        }
        
        //Convert response object to valid PKPaymentRequest
        let paymentRequest = applePay.setupTransaction(session: session, request: request)
        
        //Show native Apple Pay screen with configured PKPaymentRequest object
        guard let vc = applePay.getApplePayController(request: paymentRequest) else {
            dLog("Error instantiating Apple Pay screen")
            handleEventType(.status(.failed))
            return
        }
        vc.delegate = self
        
        assert(applePay.applePayDidAuthorize == false)
        assert(vc.delegate != nil)
        
        //disable swipe to dismiss
        if #available(iOS 13.0, *) {
            vc.isModalInPresentation = true
        }
        
        showAsTopmostController(vc: vc)
    }
}

//MARK: Redirection

extension EVOWebView: SFSafariViewControllerDelegate {
    ///User pressed done button, cancel transaction
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        closeOverlay()
        handleEventType(.status(.cancelled))
    }
}
