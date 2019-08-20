//
//  InputAccessoryToolbar.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 11/09/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit

/// A UIToolbar subclass that can be set up with a button of given kind.
/// Set `action` closure to handle tap events.
final class InputAccessoryToolbar: UIToolbar {
    typealias Tag = Int
    
    enum Kind {
        case next
        case done
    }
    
    private var action: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(kind: Kind = .next, action: @escaping (() -> Void)) {
        self.init(frame: .zero)
        
        let actionButton: UIBarButtonItem
        
        switch kind {
        case .done:
            actionButton = UIBarButtonItem(barButtonSystemItem: .done,
                                           target: self,
                                           action: #selector(doneTapAction))
        case .next:
            let nextButton = UIButton(type: .system)
            nextButton.setTitle("→", for: .normal)
            nextButton.setTitleColor(tintColor, for: .normal)
            nextButton.titleLabel?.font = .boldSystemFont(ofSize: 19.0)
            nextButton.addTarget(self, action: #selector(nextTapAction(_:)), for: .touchUpInside)
            actionButton = UIBarButtonItem(customView: nextButton)
        }
        
        self.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            actionButton
        ]
        self.sizeToFit()
        
        self.action = action
    }
    
    @objc private func doneTapAction() {
        action?()
    }
    
    @objc private func nextTapAction(_ sender: UIButton) {
        action?()
    }
    
}
