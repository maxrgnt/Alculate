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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        clipsToBounds = true
        backgroundColor = UI.Color.Menu.background
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.Menu.radii)
        buttons = [showDrinkLibrary]
        addObjectsToView()
        buttonSettings()
        constraints()
    }
    
    //MARK: Add Objects
    func addObjectsToView() {
        for obj in buttons {
            addSubview(obj)
        }
    }
        
    //MARK: Object Settings
    func buttonSettings() {
        let alignments: [UIControl.ContentHorizontalAlignment] = [.center]
        let buttonText = [Constants.menuButton]
        for (i,button) in buttons.enumerated() {
            button.tag = 1
            addSubview(button)
            button.alpha = 0.7
            button.backgroundColor = .clear
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = alignments[i]
            button.setTitle(buttonText[i], for: .normal)
            button.titleLabel?.font = UI.Font.Menu.button
            button.setTitleColor(UI.Color.Font.standard, for: .normal)
        }
    }
    
    //MARK: - Constraints
    func constraints() {
        showDrinkLibraryConstraints()
    }
}
