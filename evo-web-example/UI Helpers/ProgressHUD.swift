//
//  ProgressHUD.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 11/09/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import UIKit

final class ProgressHUD {
    
    static let shared = ProgressHUD()
    
    static func show() { shared.show() }
    static func hide() { shared.hide() }
    
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private let indicator = UIActivityIndicatorView(style: .white)
    private let background = UIView()
    
    init() {
        let centerMask: UIView.AutoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin
        ]
        
        background.autoresizingMask = centerMask
        background.backgroundColor = .black
        background.center = CGPoint(x: window.bounds.size.width/2, y: window.bounds.size.height/2)
        background.frame.size = CGSize(width: 80, height: 80)
        window.addSubview(background)
        
        indicator.autoresizingMask = centerMask
        indicator.startAnimating()
        indicator.center = background.center
        background.addSubview(indicator)
        
        window.windowLevel = .statusBar
        window.backgroundColor = .clear
    }
    
    func show() {
        window.makeKeyAndVisible()
    }
    
    func hide() {
        window.isHidden = true
    }
}
