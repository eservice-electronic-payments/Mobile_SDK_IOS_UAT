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
    private let indicator = UIActivityIndicatorView(style: .whiteLarge)
    private let background = UIView()
    
    init() {
        background.autoresizingMask = []
        background.backgroundColor = .black
        background.frame.size = CGSize(width: 80, height: 80)
        background.center = window.center
        background.layer.cornerRadius = 6
        window.addSubview(background)
        
        indicator.autoresizingMask = []//centerMask
        indicator.sizeToFit()
        indicator.startAnimating()
        indicator.center = CGPoint(x: background.bounds.size.width/2,
                                   y: background.bounds.size.height/2)
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
