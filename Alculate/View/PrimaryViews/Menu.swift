//
//  Menu.swift
//  Alculate
//
//  Created by Max Sergent on 12/1/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Menu: UIView {
    
    //MARK: - Definitions
    // Constraints
    var bottom: NSLayoutConstraint!
    // Objects
    let showDrinkLibrary = UIButton()
    var buttons: [UIButton] = []
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
        print("init summaryCell2")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        clipsToBounds = true
        backgroundColor = UI.Color.bgDarkest
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.Menu.radii)

        buttons = [showDrinkLibrary]
        
        addObjectsToView()
        buttonSettings()
//        gradientSettings()
        
        constraints()
        
    }
    
    //MARK: - Add Objects
    func addObjectsToView() {
        for obj in buttons {
            addSubview(obj)
        }
    }
    
    //MARK: - Constraints
    func constraints() {
        showDrinkLibraryConstraints()
    }
    
    //MARK: - Settings
    func buttonSettings() {
        let alignments: [UIControl.ContentHorizontalAlignment] = [.center]
        let buttonText = ["Show Drink Library"]
        for (i,button) in buttons.enumerated() {
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
    }
    
    func gradientSettings() {
        // Set origin of gradient (top left of screen)
        let gradientOrigin = CGPoint(x: 0,y: 0)
        // Set frame of gradient (header height, because status bar will be solid color)
        let gradientSize = CGSize(width: UI.Sizing.width, height: UI.Sizing.subMenuHeight*2)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        // Set color progression for gradient, alphaComponent of zero important for color shifting to
        gradient.colors = [UI.Color.bgDarkest.withAlphaComponent(0.0).cgColor,
                           UI.Color.bgDarkest.withAlphaComponent(1.0).cgColor,
                           UI.Color.bgDarkest.withAlphaComponent(1.0).cgColor]
        // Set locations of where gradient will transition
        gradient.locations = [0.1,0.25,1.0]
        // Add gradient as bottom layer in sublayer array
        self.layer.insertSublayer(gradient, at: 0)
    }
}
