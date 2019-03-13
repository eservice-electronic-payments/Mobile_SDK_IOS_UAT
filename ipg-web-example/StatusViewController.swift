//
//  StatusViewController.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit

final class StatusViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDescriptionLabel: UILabel!
    
    var status: IPGPaymentStatus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = status.statusText
        statusDescriptionLabel.text = status.statusDescription
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

