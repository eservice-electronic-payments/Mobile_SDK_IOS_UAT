//
//  ViewController.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 13/03/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import UIKit
import EvoPayments

final class ViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var actionField: PickerTextField!
    @IBOutlet private weak var customerIDField: UITextField!
    @IBOutlet private weak var customerFirstNameField: UITextField!
    @IBOutlet private weak var customerLastNameField: UITextField!
    @IBOutlet private weak var amountField: UITextField!
    @IBOutlet private weak var currencyField: UITextField!
    @IBOutlet private weak var countryField: UITextField!
    @IBOutlet private weak var languageField: UITextField!
    @IBOutlet private weak var userDeviceField: UITextField!

    @IBOutlet private weak var customerAddressHouseNameField: UITextField!
    @IBOutlet private weak var customerAddressStreetField: UITextField!
    @IBOutlet private weak var customerAddressCityField: UITextField!
    @IBOutlet private weak var customerAddressPostalCodeField: UITextField!
    @IBOutlet private weak var customerAddressCountryField: UITextField!
    @IBOutlet private weak var customerAddressStateField: UITextField!

    @IBOutlet private weak var customerEmailField: UITextField!
    @IBOutlet private weak var customerPhoneField: UITextField!

    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var webUITestButton: UIButton!

    @IBOutlet private weak var mobileCashierURLTextView: UITextView!
    @IBOutlet private weak var orderIDField: UITextField!
    @IBOutlet private weak var additionalParametersField: UITextField!
    @IBOutlet private weak var mssUrlField: PickerTextField!
    
    private let viewModel = ViewModel()

    private(set) lazy var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private var textFields: [ScrollingFormTextField] {
        return [
            actionField,
            customerIDField,
            customerFirstNameField,
            customerLastNameField,
            amountField,
            currencyField,
            countryField,
            languageField,
            userDeviceField,
            customerAddressHouseNameField,
            customerAddressStreetField,
            customerAddressCityField,
            customerAddressPostalCodeField,
            customerAddressCountryField,
            customerAddressStateField,
            customerEmailField,
            customerPhoneField,
            mobileCashierURLTextView,
            orderIDField,
            additionalParametersField,
            mssUrlField
        ].compactMap { $0 }
    }

    private let scrollingFormController = ScrollingFormController()
    private let cancelEditingRecognizer = CancelEditingRecognizer()

    private var paymentStatus: Status?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
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
        setupAmountField()
        setupOrderIDField()
        setupTextViews()
        setupButtons()

        scrollingFormController.setup(withScrollView: scrollView, fields: textFields)
        cancelEditingRecognizer.attach(to: self)
        setupMssUrlField()
    }

    private func setupActionField() {
        actionField.items = viewModel.actions
        actionField.selectAction = { [weak self] index in
            self?.didSelectAction(at: index)
        }
    }

    private func setupOrderIDField() {
        viewModel.generateOrderID { [weak self] orderID in
            self?.orderIDField.text = orderID
        }
    }

    private func setupAmountField() {
        amountField.text = amountFormatter.string(from: NSNumber(value: 1.0))
    }

    private func setupTextViews() {
        for textView in [mobileCashierURLTextView] {
            textView!.layer.cornerRadius = 5
            textView!.layer.borderWidth = 1
            textView!.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        }
    }

    private func setupButtons() {
        let tintColor: UIColor = .systemBlue
        let textColor: UIColor = .white

        startButton.backgroundColor = tintColor
        startButton.setTitleColor(textColor, for: .normal)
        startButton.layer.cornerRadius = 8

        webUITestButton.backgroundColor = .clear
        webUITestButton.setTitleColor(tintColor, for: .normal)
        webUITestButton.layer.cornerRadius = 8
        webUITestButton.layer.borderWidth = 1
        webUITestButton.layer.borderColor = tintColor.cgColor
    }
    
    private func setupMssUrlField() {
        mssUrlField.items = viewModel.mssUrls
        mssUrlField.selectAction = { [weak self] index in
            self?.didSelectMssUrl(at: index)
        }
    }

    private func didSelectAction(at index: Int) {
        viewModel.selectedActionIndex = index

        let isVerify = (viewModel.actions[index].kind == .verify)
        amountField.isEnabled = !isVerify
        if isVerify {
            // force 0
            amountField.text = amountFormatter.string(from: 0)
        }
    }
    
    private func didSelectMssUrl(at index: Int) {
        viewModel.selectedMssUrlIndex = index
    }

    // MARK: - Private - Presentation & Routing

    /// Start cashier URL
    ///
    /// A EVOWebView can be used to put this in any of your controllers
    /// or a dedicated EVOWebViewController to display it already embedded in
    /// a fullscreen UIViewController
    ///
    /// This example uses EVOWebViewController
    private func showDemo(withSession session: Session) {
        let webViewController = EVOWebViewController(session: session) { [weak self] status in
            self?.setupOrderIDField()
            self?.dismiss(animated: true) {
                self?.showStatus(status)
            }
        }

        let navigationController = webViewController.embedInNavigationController()
        navigationController.navigationBar.tintColor = .darkText
        present(navigationController, animated: true) {
            navigationController.presentationController?.delegate = self
        }
    }

    /// Show alert
    private func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    private func showStatus(_ status: Status) {
        paymentStatus = status
        performSegue(withIdentifier: "StatusSegue", sender: nil)
    }

    // MARK: - Private - IBAction

    @IBAction private func startDemoTapped(_ sender: Any) {
        guard let amount = amountFormatter.number(from: amountField.text ?? "")?.doubleValue else {
            showAlert(withTitle: "Error", message: "Please enter valid amount")
            return
        }
        
        // Get token url
        let mssItem = viewModel.mssUrls[viewModel.selectedMssUrlIndex ?? 0]
        var tokenUrl = mssItem.value
        if let manualInput = mssUrlField.text,
           manualInput != mssItem.title {
            tokenUrl = manualInput
        }

        let content = FormContent(
            action: actionField.text ?? "",
            customerID: customerIDField.text ?? "",
            customerFirstName: customerFirstNameField.text ?? "",
            customerLastName: customerLastNameField.text ?? "",
            amount: amount,
            currency: currencyField.text ?? "",
            country: countryField.text ?? "",
            language: languageField.text ?? "",
            userDevice: userDeviceField.text ?? "",
            tokenURL: tokenUrl,
            mobileCashierURL: mobileCashierURLTextView.text ?? "",
            additionalParameters: additionalParametersField.text ?? "",
            customerAddressHouseName: customerAddressHouseNameField.text ?? "",
            customerAddressStreet: customerAddressStreetField.text ?? "",
            customerAddressCity: customerAddressCityField.text ?? "",
            customerAddressPostalCode: customerAddressPostalCodeField.text ?? "",
            customerAddressCountry: customerAddressCountryField.text ?? "",
            customerAddressState: customerAddressStateField.text ?? "",
            customerEmail: customerEmailField.text ?? "",
            customerPhone: customerPhoneField.text ?? "",
            orderID: orderIDField.text ?? ""
        )

        ProgressHUD.show()
        viewModel.startSession(withContent: content) { [weak self] result in
            ProgressHUD.hide()
            guard let self = self else {
                print("self is already destroyed")
                return
            }
            
            // make sure showDemo and showAlert are running on main thread
            self.performTaskOnMainThread { [weak self] in
                switch result {
                case .success(let session):
                    self?.showDemo(withSession: session)
                case .failure(let error):
                    self?.showAlert(withTitle: "Error", message: error.errorMessage)
                }
            }
            
        }
    }

    @IBAction private func webUITestButtonTapped(_ sender: Any) {
        let defaultURL = URL(
            string: "https://cashierui-responsivedev.test.myriadpayments.com/react-frontend/index.html"
            )!
        let url = URL(string: mobileCashierURLTextView.text ?? "") ?? defaultURL

        let testSession = Session(mobileCashierUrl: url, token: "", merchantId: "")
        showDemo(withSession: testSession)
    }
}

extension ViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        setupOrderIDField()
    }
}

extension ViewController {
    /// Make sure the task is run on main thread
    func performTaskOnMainThread(task: @escaping () -> ()) {
        if Thread.isMainThread {
            task()
        } else {
            DispatchQueue.main.async {
                task()
            }
        }
    }
}

