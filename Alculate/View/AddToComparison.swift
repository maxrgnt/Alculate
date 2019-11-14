//
//  AddToComparison.swift
//  Alculate
//
//  Created by Max Sergent on 11/13/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class AddToComparison: UIView {
         
    // Constraints
    var top = NSLayoutConstraint()
    
    // Objects
    var addBeer = UIButton()
    var addLiquor = UIButton()
    var addWine = UIButton()
    
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
        let buttonText = ["Beer","Liquor","Wine"]
        for (i, button) in [addBeer,addLiquor,addWine].enumerated() {
            button.tag = 20+i
            addSubview(button)
            button.backgroundColor = UI.Color.alculatePurpleLite
            button.layer.borderWidth = UI.Sizing.containerBorder
            button.layer.borderColor = UI.Color.alculatePurpleDark.cgColor
            button.contentHorizontalAlignment = .center
            button.contentVerticalAlignment = .center
            button.titleLabel?.font = UI.Font.cellHeaderFont
            button.setTitle("+ add \(buttonText[i])", for: .normal)
            button.setTitleColor(UI.Color.softWhite, for: .normal)
            button.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.containerRadius)
        }
        
        // MARK: - Gradient Settings
        // Set origin of gradient (top left of screen)
        let gradientOrigin = CGPoint(x: 0,y: 0)
        // Set frame of gradient (header height, because status bar will be solid color)
        let gradientSize = CGSize(width: UI.Sizing.width, height: UI.Sizing.appNavigatorHeight)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        // Set color progression for gradient, alphaComponent of zero important for color shifting to
        gradient.colors = [UI.Color.alculatePurpleLite.withAlphaComponent(0.0).cgColor,
                           UI.Color.alculatePurpleDark.withAlphaComponent(1.0).cgColor,
                           UI.Color.alculatePurpleDark.withAlphaComponent(1.0).cgColor]
        // Set locations of where gradient will transition
        gradient.locations = [0.0,0.6,1.0]
        // Add gradient as bottom layer in sublayer array
        self.layer.insertSublayer(gradient, at: 0)
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [addBeer,addLiquor,addWine] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        top = topAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: UI.Sizing.topLineTop-UI.Sizing.addComparisonHeight)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.addComparisonHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            top
        ])
        for (i, button) in [addBeer,addLiquor,addWine].enumerated() {
            let offset = (CGFloat(i)*UI.Sizing.containerDiameter) + (UI.Sizing.appNavigatorConstraints[i])
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: UI.Sizing.containerDiameter),
                button.heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
                button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
                button.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
