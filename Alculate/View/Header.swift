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
    var gradient = CAGradientLayer()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        clipsToBounds = true
        // Object settings
        addSubview(appName)
        appName.textColor = UI.Color.softWhite
        appName.font = UI.Font.headerFont
        appName.textAlignment = .center
        appName.text = "Alculate"
        
        // MARK: - Gradient Settings
        // Set origin of gradient (top left of screen)
        let gradientOrigin = CGPoint(x: 0,y: 0)
        // Set frame of gradient (header height, because status bar will be solid color)
        let gradientSize = CGSize(width: UI.Sizing.width, height: UI.Sizing.headerHeight)
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        // Set color progression for gradient, alphaComponent of zero important for color shifting to
        gradient.colors = [UI.Color.alculatePurpleDark.withAlphaComponent(1.0).cgColor,
                            UI.Color.alculatePurpleLite.withAlphaComponent(1.0).cgColor,
                            UI.Color.alculatePurpleLite.withAlphaComponent(0.0).cgColor]
        // Set locations of where gradient will transition
        gradient.locations = [0,0.9,1.0]
        // Add gradient as bottom layer in sublayer array
        self.layer.insertSublayer(gradient, at: 0)
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        appName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // View constraints
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.statusBar.height),
            // Object constraints
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
