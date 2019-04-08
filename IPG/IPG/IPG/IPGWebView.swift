//
//  IPGWebView.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit
import WebKit

/// Displays WKWebView with
open class IPGWebView: UIView {
    public typealias StatusCallback = ((IPG.PaymentStatus) -> Void)?
    
    private(set) var webView: WKWebView?
    
    private var connection: IPGConnection?
    private var sessionToken: IPG.SessionToken? { return connection?.sessionToken }
    private var environment: IPG.Environment?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Load IPG payment page
    open func start(mode: IPG.Mode = .production, statusCallback: StatusCallback) {
        setupWebView()
        self.statusCallback = statusCallback
        
        switch mode {
        case .offlineDemo:
            load(.demoPage)
        case .online(let env):
            let connection = IPGConnection(environment: env)
            self.connection = connection
            self.environment = env
            
            let data = IPG.SessionTokenRequestData.testUser
            connection.requestSessionToken(data: data) { [weak self] result in
                onMainQueue {
                    switch result {
                    case .success(let token):
                        self?.continueToPayments(using: token)
                    case .error(let error):
                        dPrint(error)
                        statusCallback?(.failed)
                    }
                }
            }
        }
    }
    
    // MARK: Private
    
    private var statusCallback: StatusCallback
    private let messageHandlerName = "JSInterface"
    
    private enum PageSource {
        case local(htmlName: String)
        case url(url: URL, queryParameters: [String: CustomStringConvertible]?)
        
        static let demoPage = PageSource.local(htmlName: "demo")
    }
    
    private func continueToPayments(using token: String?) {
        guard let token = token ?? self.sessionToken else {
            assertionFailure("Session token not available")
            statusCallback?(.failed)
            return
        }
        
        guard let env = self.environment else {
            assertionFailure("Environment not set")
            statusCallback?(.failed)
            return
        }
        
        #if DEBUG
        dPrint("Using token \(token)")
        #endif
        
        load(.url(url: env.startMobilePaymentURL, queryParameters: ["token": token]))
    }
    
    private func load(_ source: PageSource) {
        switch source {
        case .local(let fileName):
            guard let path = Bundle.main.path(forResource: fileName,
                                              ofType: ".html"),
                let htmlString = try? String(contentsOfFile: path) else { return }
            
            webView?.loadHTMLString(htmlString, baseURL: nil)
        case .url(let baseUrl, let queryParams):
            let url: URL
            if let queryParams = queryParams {
                url = baseUrl.withQueryParameters(queryParams) ?? baseUrl
            } else {
                url = baseUrl
            }
            
            webView?.load(URLRequest(url: url))
        }
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

extension IPGWebView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == messageHandlerName else { return }
        
        if let statusString = message.body as? String,
            let status = IPG.PaymentStatus(rawValue: statusString) {
            statusCallback?(status)
        }
    }
}
