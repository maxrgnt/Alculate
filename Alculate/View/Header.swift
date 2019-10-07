//
//  Header.swift
//  Alculate
//
//  Created by Max Sergent on 9/24/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Header: UIView {
         
    // Objects
    let appName = UILabel()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        backgroundColor = .clear
        clipsToBounds = true
        // Object settings
        addSubview(appName)
        appName.textColor = .black
        appName.font = UI.Font.headerFont
        appName.textAlignment = .center
        appName.text = "Alculate"

        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        appName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.statusBar.height),
            appName.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
            appName.heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
            appName.centerXAnchor.constraint(equalTo: centerXAnchor),
            appName.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
