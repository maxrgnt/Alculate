//
//  Undo.swift
//  Alculate
//
//  Created by Max Sergent on 10/2/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Undo: UIView {
         
    //MARK: Definitions
    // Constraints
    var top: NSLayoutConstraint!
    // Objects
    let confirm = UIButton()
    let cancel = UIButton()
        
    //MARK: Initialization
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setup() {
        clipsToBounds = true
        backgroundColor = UI.Color.Undo.background
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.Header.radii)
    
        objectSettings()
        
        constraints()
    }
    
    //MARK: Object Settings
    func objectSettings() {
        let buttonText = ["Undo", "X"]
        let alignments: [UIControl.ContentHorizontalAlignment] = [.center, .center]
        for (i,button) in [confirm,cancel].enumerated() {
            button.tag = i
            addSubview(button)
            button.setTitleColor(UI.Color.Font.standard, for: .normal)
            button.setTitle(buttonText[i], for: .normal)
            button.titleLabel?.font = UI.Font.Undo.button
            button.contentHorizontalAlignment = alignments[i]
        }
        cancel.backgroundColor = .clear //UI.Color.bgDark
    }
    
    //MARK: - Constraints
    func constraints() {
        confirmConstraints()
        cancelConstraints()
    }
    
}
