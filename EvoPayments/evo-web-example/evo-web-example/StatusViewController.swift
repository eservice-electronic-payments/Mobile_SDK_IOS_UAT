//
//  StatusViewController.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import UIKit
import EvoPayments

final class StatusViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDescriptionLabel: UILabel!

    var status: Status!

    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.text = status.statusText
        statusDescriptionLabel.text = status.statusDescription
    }

    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension Status {
    var statusText: String {
        switch self {
        case .success: return "Success!"
        case .cancelled: return "Cancelled"
        case .started: return "Payment started"
        case .failed, .timeout, .undetermined: return "Oops :("
        }
    }

    var statusDescription: String {
        switch self {
        case .success: return "Your payment was accepted."
        case .cancelled: return "You cancelled the payment."
        case .failed: return "We could not process your payment."
        case .timeout: return "Your payment has timed out."
        case .undetermined: return "We could not determine the result of your payment."
        case .started: return "Your payment was started. Please be patient."
        }
    }
}
