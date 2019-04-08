//
//  ViewController.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit
import IPG

final class ViewController: UIViewController {

    private var paymentStatus: IPG.PaymentStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startDemoPaymentTapped(_ sender: Any) {
        
        // You can either use a dedicated IPGWebViewController to display a full screen payment
        // or embed IPGWebView manually anywhere in your controllers
        let ipgWebViewController = IPGWebViewController(mode: .online(.userAcceptanceTesting)) { [weak self] status in
            self?.paymentStatus = status
            
            self?.dismiss(animated: true) {
                self?.performSegue(withIdentifier: "StatusSegue", sender: nil)
            }
        }
        
        present(ipgWebViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statusViewController = segue.destination as? StatusViewController,
            let status = paymentStatus {
            statusViewController.status = status
        }
    }
}

