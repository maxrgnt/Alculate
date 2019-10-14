//
//  TextNavigation.swift
//  Alculate
//
//  Created by Max Sergent on 10/14/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TextNavigation: UIView {
         
    // Constraints
    static var bottom = NSLayoutConstraint()
    
    // Objects
    let exit = UIButton()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        backgroundColor = .clear
        clipsToBounds = true
        //
        let titles = ["exit"]
        for (i, button) in [exit].enumerated() {
            button.tag = i-1
            addSubview(button)
            button.backgroundColor = .clear
            button.setTitle(titles[i], for: .normal)
            button.contentHorizontalAlignment = .left
        }
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [exit] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        TextNavigation.bottom = bottomAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: -UI.Sizing.keyboard)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigationWidth),
            heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigationHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.objectPadding),
            TextNavigation.bottom,
            exit.leadingAnchor.constraint(equalTo: leadingAnchor),
            exit.widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigationWidth/3),
            exit.heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigationHeight),
            exit.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
