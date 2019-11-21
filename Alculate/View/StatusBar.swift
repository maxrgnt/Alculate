//
//  StatusBar.swift
//  Alculate
//
//  Created by Max Sergent on 10/7/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class StatusBar: UIView {
    
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // View constraints
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.statusBar.height),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            topAnchor.constraint(equalTo: ViewController.topAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
