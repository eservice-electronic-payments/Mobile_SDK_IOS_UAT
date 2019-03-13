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
final class IPGWebView: UIView {
    typealias StatusCallback = ((IPGPaymentStatus) -> Void)?
    
    private(set) var webView: WKWebView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Load IPG payment page
    func start(mode: IPGMode = .normal,
               statusCallback: StatusCallback) {
        setupWebView()
        load(mode == .demo ? .demoPage : .productionURL)
        self.statusCallback = statusCallback
    }
    
    // MARK: Private
    
    private var statusCallback: StatusCallback
    private let messageHandlerName = "JSInterface"
    
    private enum PageSource {
        case local(htmlName: String)
        case url(url: URL)
        
        static let demoPage = PageSource.local(htmlName: "demo")
        static let productionURL = PageSource.url(url: URL(string: "https://google.com/")!)
    }
    
    private func load(_ source: PageSource) {
        switch source {
        case .local(let fileName):
            guard let path = Bundle.main.path(forResource: fileName,
                                              ofType: ".html"),
                let htmlString = try? String(contentsOfFile: path) else { return }
            
            webView?.loadHTMLString(htmlString, baseURL: nil)
        case .url(let url):
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
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == messageHandlerName else { return }
        
        if let statusString = message.body as? String,
            let status = IPGPaymentStatus(rawValue: statusString) {
            statusCallback?(status)
        }
    }
}
