//
//  EVOWebView.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit
import WebKit

/// A WKWebView wrapper that handled EvoPayments callbacks out of the box
open class EVOWebView: UIView {
    public typealias StatusCallback = ((Evo.PaymentStatus) -> Void)
    
    private(set) var webView: WKWebView?
    
    private var statusCallback: StatusCallback?
    private var session: Evo.Session?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Make sure to start from main thread
    open func start(session: Evo.Session, statusCallback: @escaping StatusCallback) {
        setupWebView()
        
        self.session = session
        self.statusCallback = statusCallback
        
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
        func callStatus(_ status: Evo.PaymentStatus) {
            DispatchQueue.main.async {
                self.statusCallback?(status)
            }
        }
        
        guard message.name == messageHandlerName else { return }
        
        if let statusString = message.body as? String {
            if let status = Evo.PaymentStatus(rawValue: statusString) {
                callStatus(status)
                dLog("Received status: \(status)")
            } else {
                callStatus(.failed)
                dLog("Unknown status received: \"\(statusString)\"")
            }
        }
    }
}
