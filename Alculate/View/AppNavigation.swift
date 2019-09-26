//
//  AppNavigation.swift
//  Alculate
//
//  Created by Max Sergent on 9/25/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class AppNavigation: UIView {
         
    // Objects
    let left = UIButton()
    let middle = UIButton()
    let right = UIButton()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .darkGray
        clipsToBounds = true
        // Object settings
        left.contentHorizontalAlignment = .left
        middle.contentHorizontalAlignment = .center
        right.contentHorizontalAlignment = .right
        let buttons = [left, middle, right]
        let buttonText = ["X", "+", "//"]
        for i in 0..<buttons.count {
            buttons[i].translatesAutoresizingMaskIntoConstraints = false
            buttons[i].setTitle(buttonText[i], for: .normal)
            addSubview(buttons[i])
            buttons[i].tag = i-1
        }
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            bottomAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: -UI.Sizing.statusBar.height),
            left.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            middle.centerXAnchor.constraint(equalTo: centerXAnchor),
            right.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding)
            ])
        for i in 0..<buttons.count {
            NSLayoutConstraint.activate([
                buttons[i].widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/3),
                buttons[i].heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
                buttons[i].bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
