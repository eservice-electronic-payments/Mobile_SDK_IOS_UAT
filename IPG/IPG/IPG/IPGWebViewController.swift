//
//  IPGWebViewController.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit

open class IPGWebViewController: UIViewController {
    
    private let statusCallback: IPGWebView.StatusCallback
    
    open var ipgWebView: IPGWebView? {
        return view as? IPGWebView
    }
    
    override open func loadView() {
        super.loadView()
        let ipgWebView = IPGWebView()
        self.view = ipgWebView
    }
    
    public init(statusCallback: IPGWebView.StatusCallback) {
        self.statusCallback = statusCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        ipgWebView?.start(statusCallback: { [weak self] status in
                            self?.statusCallback?(status)
        })
    }
}
