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
    var bottom: NSLayoutConstraint!
    
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
        backgroundColor = UI.Color.alculatePurpleDark
        let buttonText = ["Undo", "X"]
        let alignments: [UIControl.ContentHorizontalAlignment] = [.center, .center]
        for (i,button) in [confirm,cancel].enumerated() {
            button.tag = i
            addSubview(button)
            button.setTitleColor(UI.Color.softWhite, for: .normal)
            button.setTitle(buttonText[i], for: .normal)
            button.contentHorizontalAlignment = alignments[i]
        }
        cancel.backgroundColor = UI.Color.alculatePurpleLite
        cancel.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.undoCancelRadius)
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [confirm,cancel] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        bottom = bottomAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: UI.Sizing.undoHeight)
        NSLayoutConstraint.activate([
            // View constraints
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.undoHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            bottom,
            // Object constraints
            confirm.widthAnchor.constraint(equalToConstant: UI.Sizing.undoConfirmWidth),
            confirm.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirm.heightAnchor.constraint(equalToConstant: UI.Sizing.undoConfirmHeight),
            confirm.topAnchor.constraint(equalTo: topAnchor, constant: UI.Sizing.objectPadding),
            cancel.widthAnchor.constraint(equalToConstant: UI.Sizing.undoCancelDiameter),
            cancel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            cancel.heightAnchor.constraint(equalToConstant: UI.Sizing.undoCancelDiameter),
            cancel.topAnchor.constraint(equalTo: topAnchor, constant: UI.Sizing.objectPadding)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
