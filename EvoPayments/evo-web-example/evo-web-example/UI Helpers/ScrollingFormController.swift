//
//  ScrollingFormController.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 11/09/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import UIKit

protocol ScrollingFormTextField: UIView {
    var keyboardType: UIKeyboardType { get }
    var inputAccessoryView: UIView? { get set }
}

/// use to attach UIToolbar to custom UITextFields subclasses
protocol ScrollingFormToolbarEquippedTextField: UITextField {
    func toggleKeyboard()
}

enum InputType {
    case keyboard
    case picker
}

/// Manages UITextFields within scrollView
///
/// 1. Adds auto-support for focusing next responder or resigning thee current one if none left.
/// 2. Manages scrolling the keyboard properly up to focused UITextField.
/// 3. Automatically adds InputAccessoryToolbar (a subclass of UIToolbar) to UITextFields
/// that do not feature keyboard with next/done button (or that conform to ScrollingFormToolbarEquippedTextField)
///
/// Usage:
/// - call setup(withScrollView:fields:) with a scrollView and form UITextFields
///   (the order determines the responder chain order!)
///
/// Dependencies:
/// - InputAccessoryToolbar
///
final class ScrollingFormController: NSObject {
    typealias Field = ScrollingFormTextField

    private weak var scrollView: UIScrollView!
    private weak var activeTextField: Field?
    private var textFields: [Field] = []

    private var observers: [NSKeyValueObservation] = []
    private var keyboardHeight: CGFloat = 0

    override init() {
        super.init()
        setupKeyboardObservers()
    }

    // MARK: - Internal

    func setup(withScrollView scrollView: UIScrollView,
               fields textFields: [Field]) {
        self.scrollView = scrollView
        setupFormFields(textFields)
    }

    // MARK: - Private - Set up

    private func setActiveTextField(to textField: Field?) {
        self.activeTextField = textField
        adjustScrollViewOffset()
    }

    private func setupFormFields(_ textFields: [Field]) {
        self.observers.forEach { $0.invalidate() }
        self.observers.removeAll()

        self.textFields = textFields

        for field in textFields {

            if let textField = field as? UITextField {
                textField.delegate = self
            } else if let textView = field as? UITextView {
                textView.delegate = self

                // watch size changes when editing to adjust keyboard
                let observer = textView.observe(\.bounds) { [weak self] _, _ in
                    self?.adjustScrollViewOffset(false)
                }

                self.observers.append(observer)
            }

            let toolbarTypes: [UIKeyboardType] = [.decimalPad, .numberPad]

            if toolbarTypes.contains(field.keyboardType) || field is ScrollingFormToolbarEquippedTextField {
                // attach toolbar to show next/done button there
                // as its not included in the keyboard for these types
                attachInputAccessoryToolbar(to: field)
            }
        }
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidChange),
                                               name: UIView.keyboardDidChangeFrameNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIView.keyboardWillHideNotification,
                                               object: nil)
    }

    private func adjustScrollViewOffset(_ animated: Bool = true) {
        guard let activeTextField = activeTextField else {
            let adjustedTopInset: CGFloat

            if #available(iOS 11, *) {
                adjustedTopInset = scrollView.adjustedContentInset.top
            } else {
                adjustedTopInset = 0
            }

            let scrollMaxY = max(
                scrollView.contentSize.height - scrollView.bounds.size.height - adjustedTopInset, -adjustedTopInset
            )

            if scrollView.contentOffset.y > scrollMaxY {
                let contentOffset = CGPoint(x: 0, y: scrollMaxY)
                scrollView.setContentOffset(contentOffset, animated: animated)
            }
            return
        }

        let toolbarHeight: CGFloat = (activeTextField.inputAccessoryView?.bounds.size.height ?? 0)
        let padding: CGFloat = 24
        let totalKeyboardHeight = keyboardHeight + toolbarHeight + padding

        let fieldYOffset = activeTextField.superview!.convert(activeTextField.frame, to: scrollView).minY
        let scrollViewHeight = scrollView.bounds.size.height
        let activeTextFieldHeight = activeTextField.bounds.size.height
        let yOffset = fieldYOffset - scrollViewHeight + totalKeyboardHeight + activeTextFieldHeight

        if yOffset > 0 {
            let contentOffset = CGPoint(x: 0, y: yOffset)
            scrollView.setContentOffset(contentOffset, animated: animated)
        }
    }

    // MARK: - Private - Keyboard

    @objc private func keyboardDidChange(_ notification: Notification) {
        guard let keyboardSizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            assertionFailure("Keyboard size not available")
            return
        }

        keyboardHeight = keyboardSizeValue.cgRectValue.height
        adjustScrollViewOffset()
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = 0
        adjustScrollViewOffset()
    }

    // MARK: - Private - Form fields handling

    private func attachInputAccessoryToolbar(to field: Field, isLastField: Bool = false) {
        let buttonKind: InputAccessoryToolbar.Kind = (isLastField ? .done : .next)

        field.inputAccessoryView = InputAccessoryToolbar(kind: buttonKind, toggleInputAction: {
            if let field = field as? ScrollingFormToolbarEquippedTextField {
                field.toggleKeyboard()
            }
        }) { [unowned self, unowned field] in
            // Will resign if no subsequent text field found
            self.focusNextResponder(for: field)
        }
    }

    private func focusNextResponder(for sender: Field) {
        sender.resignFirstResponder()

        guard let currentFieldIndex = textFields.firstIndex(where: { $0 === sender }) else { return }
        let nextFieldIndex = currentFieldIndex + 1

        if nextFieldIndex < textFields.count {
            textFields[nextFieldIndex].becomeFirstResponder()
        }
    }
}

extension ScrollingFormController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setActiveTextField(to: textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        setActiveTextField(to: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        focusNextResponder(for: textField)
        return true
    }
}

extension ScrollingFormController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setActiveTextField(to: textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        setActiveTextField(to: nil)
    }
}

extension UITextField: ScrollingFormTextField {}
extension UITextView: ScrollingFormTextField {}
