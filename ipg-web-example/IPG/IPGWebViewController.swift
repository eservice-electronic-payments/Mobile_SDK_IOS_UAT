//
//  IPGWebViewController.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit

final class IPGWebViewController: UIViewController {
    
    private let statusCallback: IPGWebView.StatusCallback
    private let mode: IPGMode
    
    var ipgWebView: IPGWebView? {
        return view as? IPGWebView
    }
    
    override func loadView() {
        super.loadView()
        let ipgWebView = IPGWebView()
        self.view = ipgWebView
    }
    
    init(mode: IPGMode = .normal, statusCallback: IPGWebView.StatusCallback) {
        self.mode = mode
        self.statusCallback = statusCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        ipgWebView?.start(mode: mode,
                          statusCallback: { [weak self] status in
                            self?.statusCallback?(status)
        })
    }
}
