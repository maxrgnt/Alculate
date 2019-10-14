//
//  ComparisonHeader.swift
//  Alculate
//
//  Created by Max Sergent on 10/9/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class ComparisonHeader: UIView {
         
    // Objects
    let icon = UIImageView()
    var gradient = CAGradientLayer()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build(iconName: String, leadingConstant: CGFloat) {
        // MARK: - View/Object Settings
        // View settings
        clipsToBounds = true
        backgroundColor = .clear //UI.Color.alculatePurpleLite
        // Object settings
        addSubview(icon)
        icon.image = UIImage(named: iconName)
        
        // MARK: - Gradient Settings
        // Set origin of gradient (top left of screen)
        let gradientOrigin = CGPoint(x: 0,y: 0)
        // Set frame of gradient (header height, because status bar will be solid color)
        let gradientSize = CGSize(width: UI.Sizing.width, height: UI.Sizing.comparisonHeaderHeight)
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        // Set color progression for gradient, alphaComponent of zero important for color shifting to
        gradient.colors = [UI.Color.alculatePurpleDark.withAlphaComponent(1.0).cgColor,
                           UI.Color.alculatePurpleDark.withAlphaComponent(1.0).cgColor,
                           UI.Color.alculatePurpleLite.withAlphaComponent(1.0).cgColor]
        // Set locations of where gradient will transition
        gradient.locations = [0.0,0.5,1.0]
        // Add gradient as bottom layer in sublayer array
        self.layer.insertSublayer(gradient, at: 0)
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // View constraints
            widthAnchor.constraint(equalToConstant: UI.Sizing.comparisonHeaderWidth),
            heightAnchor.constraint(equalToConstant: UI.Sizing.comparisonHeaderHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: leadingConstant),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.comparisonHeaderTop),
            // Object constraints
            icon.widthAnchor.constraint(equalToConstant: UI.Sizing.comparisonIconDiameter),
            icon.heightAnchor.constraint(equalToConstant: UI.Sizing.comparisonIconDiameter),
            icon.centerXAnchor.constraint(equalTo: centerXAnchor),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
