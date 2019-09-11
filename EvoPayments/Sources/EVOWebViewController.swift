//
//  EVOWebViewController.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit

/// A UIViewController wrapper for fullscreen display of EVOWebView
open class EVOWebViewController: UIViewController {
    
    private let statusCallback: EVOWebView.StatusCallback
    private let session: Evo.Session
    
    open var evoWebView: EVOWebView? {
        return view as? EVOWebView
    }
    
    override open func loadView() {
        super.loadView()
        let evoWebView = EVOWebView()
        self.view = evoWebView
    }
    
    /// Creates a UINavigationController that has this EVOWebViewController set as root
    /// Also adds `done` button that dismisses the controller
    open func embedInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(dismissController))
        return navigationController
    }
    
    /// Instantiates a EVOWebViewController, containing EVOWebView.
    /// It can be used like any other UIViewController.
    ///
    /// - Parameters:
    ///     - session: Evo.Session object
    ///     - statusCallback: Called once a status has been received from the web
    public init(session: Evo.Session, statusCallback: @escaping EVOWebView.StatusCallback) {
        self.session = session
        self.statusCallback = statusCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        evoWebView?.start(session: session,
                          statusCallback: { [weak self] status in
            self?.statusCallback(status)
        })
    }
    
    // MARK: - Private
    
    /// Used for done button when embedInNavigationController() is called
    @objc private func dismissController() {
        navigationController?.dismiss(animated: true)
    }
}
