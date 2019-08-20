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
    struct Content {
        let action: String
        let merchantID: String
        let password: String
        let customerID: String
        let amount: String
        let currency: String
        let country: String
        let language: String
    }

    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var actionField: PickerTextField!
    @IBOutlet private weak var merchantIDField: UITextField!
    @IBOutlet private weak var merchantPasswordField: UITextField!
    @IBOutlet private weak var customerIDField: UITextField!
    @IBOutlet private weak var amountField: UITextField!
    @IBOutlet private weak var currencyField: UITextField!
    @IBOutlet private weak var countryField: UITextField!
    @IBOutlet private weak var languageField: UITextField!
    @IBOutlet private weak var startButton: UIButton!
    
    private lazy var viewModel: ViewModel = {
        let viewModel = ViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    private var textFields: [UITextField] {
        return [actionField, merchantIDField, merchantPasswordField,
                customerIDField, amountField, currencyField,
                countryField, languageField].compactMap { $0 }
    }
    
    private let scrollingFormController = ScrollingFormController()
    private let cancelEditingRecognizer = CancelEditingRecognizer()
    
    private var paymentStatus: Evo.PaymentStatus?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statusViewController = segue.destination as? StatusViewController {
            if let status = paymentStatus {
                statusViewController.status = status
            } else {
                assertionFailure("Expected payment status")
            }
        }
    }
    
    // MARK: - Private - UI
    
    private func setupUI() {
        setupActionField()
        setupStartButton()
        
        scrollingFormController.setup(withScrollView: scrollView, fields: textFields)
        cancelEditingRecognizer.attach(to: self)
    }
    
    private func setupActionField() {
        actionField.items = viewModel.actions
        actionField.selectAction = { [weak self] index in
            self?.didSelectAction(at: index)
        }
    }
    
    private func setupStartButton() {
        let tintColor: UIColor = .blue
        startButton.backgroundColor = .clear
        startButton.setTitleColor(tintColor, for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = tintColor.cgColor
    }
    
    private func didSelectAction(at index: Int) {
        viewModel.selectedActionIndex = index
        
        let isVerify = (viewModel.actions[index].kind == .verify)
        amountField.isEnabled = !isVerify
        if isVerify {
            // force 0
            amountField.text = viewModel.amountFormatter.string(from: 0)
        }
    }
    
    // MARK: - Private - Routing
    
    private func showStatus(_ status: Evo.PaymentStatus) {
        paymentStatus = status
        performSegue(withIdentifier: "StatusSegue", sender: nil)
    }
    
    // MARK: - Private - IBAction
    
    @IBAction private func startDemoTapped(_ sender: Any) {
        let content = Content(
            action: actionField.text ?? "",
            merchantID: merchantIDField.text ?? "",
            password: merchantPasswordField.text ?? "",
            customerID: customerIDField.text ?? "",
            amount: amountField.text ?? "",
            currency: currencyField.text ?? "",
            country: countryField.text ?? "",
            language: languageField.text ?? ""
        )
        
        viewModel.startDemo(withContent: content)
    }
}

extension ViewController: ViewModelDelegate {
    /// Start cashier URL
    ///
    /// A EVOWebView can be used to put this in any of your controllers
    /// or a dedicated EVOWebViewController to display it already embedded in
    /// a fullscreen UIViewController
    ///
    /// This example uses EVOWebViewController
    func startCashier(withSession session: Evo.Session) {
        let webViewController = EVOWebViewController(session: session) { [weak self] status in
            self?.dismiss(animated: true) {
                self?.showStatus(status)
            }
        }
        
        let navigationController = webViewController.embedInNavigationController()
        navigationController.navigationBar.tintColor = .darkText
        present(navigationController, animated: true)
    }
    
    /// Show error alert
    func showAlert(withErrorMessage errorMessage: String) {
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        present(alert, animated: true)
    }
}
