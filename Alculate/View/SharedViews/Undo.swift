//
//  Undo.swift
//  Alculate
//
//  Created by Max Sergent on 10/2/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Undo: UIView {
         
    // Constraints
    var top: NSLayoutConstraint!
    
    // Objects
    let confirm = UIButton()
    let cancel = UIButton()
        
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        clipsToBounds = true
        backgroundColor = UI.Color.Undo.background
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.Radii.header)
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
//        cancel.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.Radii.header)
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [confirm,cancel] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        top = topAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([
            // View constraints
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.Undo.height),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            top,
            // Object constraints
            confirm.widthAnchor.constraint(equalToConstant: UI.Sizing.Undo.confirmWidth),
            confirm.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirm.heightAnchor.constraint(equalToConstant: UI.Sizing.Undo.confirmHeight),
            confirm.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            cancel.widthAnchor.constraint(equalToConstant: UI.Sizing.Undo.cancelDiameter),
            cancel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            cancel.heightAnchor.constraint(equalToConstant: UI.Sizing.Undo.cancelDiameter),
            cancel.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
