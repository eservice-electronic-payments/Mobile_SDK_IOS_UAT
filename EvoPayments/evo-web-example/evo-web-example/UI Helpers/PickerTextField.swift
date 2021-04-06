//
//  PickerTextField.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 11/09/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import UIKit

protocol PickerTextFieldItemProtocol {
    var title: String { get }
}

/// A UITextField subclass which handles UIPickerView input accessory
/// and selection logic.
///
/// Set `items` property to set up picker items
/// Set `defaultSelectedIndex` to change item selected by default
/// Set `selectAction` to receive selection events
final class PickerTextField: UITextField, ScrollingFormToolbarEquippedTextField {
    typealias Index = Int

    private lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()

    var defaultSelectedIndex: Int = 0 {
        didSet {
            selectItem(at: defaultSelectedIndex)
        }
    }

    var items: [PickerTextFieldItemProtocol] = [] {
        didSet {
            picker.reloadAllComponents()
            selectDefaultItem()
        }
    }

    var selectAction: ((Index) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func selectItem(at index: Int) {
        if 0..<items.count ~= index {
            picker.selectRow(index, inComponent: 0, animated: false)
            self.text = items[index].title
        } else {
            self.text = ""
        }

        self.resignFirstResponder()

        selectAction?(index)
    }

    // MARK: - Private

    private func commonInit() {
        self.inputView = picker
        self.tintColor = .clear
    }

    private func selectDefaultItem() {
        selectItem(at: defaultSelectedIndex)
    }
}

extension PickerTextField: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectItem(at: row)
    }
}

// MARK: - String item support - mappable with PickerTextFieldItem($0) initializer

struct PickerTextFieldItem: PickerTextFieldItemProtocol {
    let title: String

    init(_ string: String) {
        self.title = string
    }
}
