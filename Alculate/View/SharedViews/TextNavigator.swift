//
//  TextNavigation.swift
//  Alculate
//
//  Created by Max Sergent on 10/14/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TextNavigator: UIView {
         
    // Constraints
    static var bottom = NSLayoutConstraint()
    var forwardBottom = NSLayoutConstraint()
    var backwardBottom = NSLayoutConstraint()
    var suggestionBottom = NSLayoutConstraint()
    var doneBottom = NSLayoutConstraint()
    
    // Objects
    let suggestion = UIButton()
    let backward = UIButton()
    let forward = UIButton()
    let done = UIButton()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        backgroundColor = .clear
        clipsToBounds = true
        //
        let titles = ["back","next","done"]
//        let alignments: [UIControl.ContentHorizontalAlignment] = [.center,.center,.center]
        for (i, button) in [backward,forward,done].enumerated() {
            button.tag = (i==0) ? -1 : 1
            addSubview(button)
            button.backgroundColor = .clear
            button.setTitle(titles[i], for: .normal)
            button.titleLabel?.font = UI.Font.TextEntry.navigator
            button.setTitleColor(UI.Color.Font.standard, for: .normal)
            button.contentHorizontalAlignment = .center //alignments[i]
        }
        //
        addSubview(suggestion)
        suggestion.tag = 2
        suggestion.backgroundColor = .clear
        suggestion.titleLabel?.font = UI.Font.TextEntry.navigator
        suggestion.setTitle("Use 'Coors Light'", for: .normal)
        suggestion.setTitleColor(UI.Color.Font.standard, for: .normal)
        suggestion.contentHorizontalAlignment = .left
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [suggestion,backward,forward,done] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        forwardBottom = forward.bottomAnchor.constraint(equalTo: bottomAnchor)
        backwardBottom = backward.bottomAnchor.constraint(equalTo: bottomAnchor)
        suggestionBottom = suggestion.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UI.Sizing.TextEntry.Navigator.height)
        doneBottom = done.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UI.Sizing.TextEntry.Navigator.height)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.height),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.objectPadding),
            forward.trailingAnchor.constraint(equalTo: trailingAnchor),
            forward.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.buttonWidth),
            forward.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.height),
            forwardBottom,
            backward.centerXAnchor.constraint(equalTo: centerXAnchor),
            backward.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.buttonWidth),
            backward.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.height),
            backwardBottom,
            suggestion.leadingAnchor.constraint(equalTo: leadingAnchor),
            suggestion.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Field.width),
            suggestion.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.height),
            suggestionBottom,
            done.trailingAnchor.constraint(equalTo: trailingAnchor),
            done.widthAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.buttonWidth),
            done.heightAnchor.constraint(equalToConstant: UI.Sizing.TextEntry.Navigator.height),
            doneBottom
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
