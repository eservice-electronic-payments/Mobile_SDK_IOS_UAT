//
//  CancelEditingRecognizer.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 11/09/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit

final class CancelEditingRecognizer {
    
    weak var viewController: UIViewController!
    
    func attach(to viewController: UIViewController) {
        let stopEditingRecognizer = UITapGestureRecognizer(target: self, action: #selector(finishEditing))
        stopEditingRecognizer.cancelsTouchesInView = false
        viewController.view.addGestureRecognizer(stopEditingRecognizer)
        
        self.viewController = viewController
    }
    
    @objc private func finishEditing() {
        viewController.view.endEditing(false)
    }
    
}
