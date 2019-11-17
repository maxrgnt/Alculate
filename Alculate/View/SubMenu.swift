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
        // MARK: - View/Object Settings
        // View settings
        backgroundColor = .clear
        clipsToBounds = true
        // Object settings
        let alignments: [UIControl.ContentHorizontalAlignment] = [.center]
        let buttonText = ["Saved ABVs"]
        for (i,button) in [showSavedABV].enumerated() {
            button.tag = 1
            addSubview(button)
            button.alpha = 0.7
            button.backgroundColor = .clear
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = alignments[i]
            button.setTitle(buttonText[i], for: .normal)
            button.titleLabel?.font = UI.Font.cellHeaderFont
            button.setTitleColor(UI.Color.fontWhite, for: .normal)
        }
        
        // MARK: - Gradient Settings
        // Set origin of gradient (top left of screen)
        let gradientOrigin = CGPoint(x: 0,y: 0)
        // Set frame of gradient (header height, because status bar will be solid color)
        let gradientSize = CGSize(width: UI.Sizing.width, height: UI.Sizing.subMenuHeight)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        // Set color progression for gradient, alphaComponent of zero important for color shifting to
        gradient.colors = [UI.Color.bgDarkest.withAlphaComponent(0.0).cgColor,
                           UI.Color.bgDarkest.withAlphaComponent(1.0).cgColor,
                           UI.Color.bgDarkest.withAlphaComponent(1.0).cgColor]
        // Set locations of where gradient will transition
        gradient.locations = [0.2,0.5,1.0]
        // Add gradient as bottom layer in sublayer array
        self.layer.insertSublayer(gradient, at: 0)
        
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
                button.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/2),
                button.heightAnchor.constraint(equalToConstant: (2/3)*UI.Sizing.subMenuHeight),
                button.topAnchor.constraint(equalTo: topAnchor)
            ])
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
