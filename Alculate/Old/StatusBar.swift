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
        // Set background color you want to mask the status bar as
        backgroundColor = UI.Color.bgDarkest
    }
    
    func build(leading: NSLayoutXAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // View constraints
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.statusBar.height),
            leadingAnchor.constraint(equalTo: leading),
            topAnchor.constraint(equalTo: ViewController.topAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
