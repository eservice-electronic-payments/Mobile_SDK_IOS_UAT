//
//  ViewController.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit
import EvoPayments

final class ViewController: UIViewController {

    private var paymentStatus: Evo.PaymentStatus?

    @IBAction func startDemoTapped(_ sender: Any) {
        startDemo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statusViewController = segue.destination as? StatusViewController,
            let status = paymentStatus {
            statusViewController.status = status
        }
    }
    
    // MARK: - Private
    
    /// Obtain a session token from a demo provider
    /// This is an example implementation
    private func startDemo() {
        let data = SessionRequestData(
            tokenUrl: "https://cashierui-responsivedev.test.myriadpayments.com/ajax/tokenJson",
            merchantId: "666",
            customerId: "sample-002"
        )
        
        let provider = SessionProvider()
        provider.requestSession(using: data) { [weak self] result in
            switch result {
            case .success(let session): self?.startCashier(withSession: session)
            case .failure(let error): self?.showError(error)
            }
        }
    }
    
    /// Start cashier URL
    ///
    /// A EVOWebView can be used to put this in any of your controllers
    /// or a dedicated EVOWebViewController to display it already embedded in
    /// a fullscreen UIViewController
    ///
    /// This example uses EVOWebViewController
    private func startCashier(withSession session: Evo.Session) {
        let webViewController = EVOWebViewController(session: session) { [weak self] status in
            self?.paymentStatus = status
            
            self?.dismiss(animated: true) {
                self?.performSegue(withIdentifier: "StatusSegue", sender: nil)
            }
        }
        
        present(webViewController, animated: true)
    }
    
    /// Show session obtain error alert
    /// This is an example implementation
    private func showError(_ error: SessionProvider.Error) {
        let message: String
        
        switch error {
        case .buildRequestFailed: message = "Could not build session request"
        case .connectionError(let error): message = "Connection error (\(String(describing: error))"
        case .decodingError(let error): message = "Could not decode session (\(String(describing: error))"
        case .invalidStatusCode(let statusCode): message = "Invalid status code \(statusCode)"
        case .responseMissing: message = "Response not received"
        }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        present(alert, animated: true)
    }
}

