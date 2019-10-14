//
//  InputNavigation.swift
//  Alculate
//
//  Created by Max Sergent on 9/25/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class InputNavigation: UIView {
         
    // Objects
    let left = UIButton()
    let middle = UIButton()
    let right = UIButton()
    
    static var bottom = NSLayoutConstraint()
    
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
        let buttons = [middle, left, right]
        let buttonText = ["back", "exit", "continue"]
        for i in 0..<buttons.count {
            buttons[i].translatesAutoresizingMaskIntoConstraints = false
            buttons[i].setTitle(buttonText[i], for: .normal)
            addSubview(buttons[i])
            buttons[i].tag = i-1
        }
        // MARK: - NSLayoutConstraints
        InputNavigation.bottom = bottomAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: -UI.Sizing.keyboard)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            InputNavigation.bottom,
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
