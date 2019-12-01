//
//  SubMenu.swift
//  Alculate
//
//  Created by Max Sergent on 10/11/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class SubMenu: UIView {
         
    // Constraints
    var top = NSLayoutConstraint()
    
    // Objects
    var showSavedABV = UIButton()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [showSavedABV] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        top = topAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: -UI.Sizing.subMenuHeight)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.subMenuHeight+UI.Sizing.subMenuBounceBuffer),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            top,
            showSavedABV.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        for button in [showSavedABV] {
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
                button.heightAnchor.constraint(equalToConstant: (2/3)*UI.Sizing.subMenuHeight),
                button.topAnchor.constraint(equalTo: topAnchor)
            ])
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
