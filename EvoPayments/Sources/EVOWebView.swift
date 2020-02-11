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
    private var safariWindow: UIWindow?
    
    private var statusCallback: StatusCallback?
    private var session: Evo.Session?
    
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
        
        webView?.load(URLRequest(url: url))
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
    
    private func handleEventType(_ eventType: Evo.EventType) {
        switch eventType {
        case .action(let action):
            switch action {
            case .redirection(let url):
                openSafari(at: url)
                dLog("Redirecting to \(url)")
//                dLog("Saari Window Visible After redirect: \(safariWindow?.isKeyWindow)")
            case .close:
                closeSafari()
                break
            }
        case .status(let status):
            closeSafari()
            
            callStatus(status)
            dLog("Received status: \(status)")
        }
    }
    
    private func callStatus(_ status: Evo.Status) {
        DispatchQueue.main.async {
            self.statusCallback?(status)
        }
    }
    
    private func openSafari(at url: URL) {
        let safari = SFSafariViewController(url: url)
        safari.delegate = self
        
        if #available(iOS 13.0, *), let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            safariWindow = UIWindow(windowScene: scene)
        } else {
            safariWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        guard let safariWindow = safariWindow else {
            dLog("Safari Window nil")
            assertionFailure()
            return
        }
        safariWindow.windowLevel = .statusBar + 1
        safariWindow.rootViewController = safari
        safariWindow.makeKeyAndVisible()
//        dLog("Safari Window Frame: \(safariWindow.frame)")
//        dLog("Safari Window Visible: \(safariWindow.isKeyWindow)")
    }
    
    private func closeSafari() {
        safariWindow?.isHidden = true
        safariWindow = nil
    }
}

extension EVOWebView: SFSafariViewControllerDelegate {
    ///User pressed done button, cancel transaction
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        closeSafari()
        handleEventType(.status(.cancelled))
    }
}
