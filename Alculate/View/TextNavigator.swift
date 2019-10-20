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
            button.setTitleColor(UI.Color.softWhite, for: .normal)
            button.contentHorizontalAlignment = .center //alignments[i]
        }
        //
        addSubview(suggestion)
        suggestion.backgroundColor = .clear
        suggestion.setTitle("Use 'Coors Light'", for: .normal)
        suggestion.setTitleColor(UI.Color.softWhite, for: .normal)
        suggestion.contentHorizontalAlignment = .left
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [suggestion,backward,forward,done] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        forwardBottom = forward.bottomAnchor.constraint(equalTo: bottomAnchor)
        backwardBottom = backward.bottomAnchor.constraint(equalTo: bottomAnchor)
        suggestionBottom = suggestion.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UI.Sizing.textNavigatorHeight)
        doneBottom = done.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UI.Sizing.textNavigatorHeight)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorWidth),
            heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.objectPadding),
            forward.trailingAnchor.constraint(equalTo: trailingAnchor),
            forward.widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorButtonWidth),
            forward.heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            forwardBottom,
            backward.centerXAnchor.constraint(equalTo: centerXAnchor),
            backward.widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorButtonWidth),
            backward.heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            backwardBottom,
            suggestion.leadingAnchor.constraint(equalTo: leadingAnchor),
            suggestion.widthAnchor.constraint(equalToConstant: UI.Sizing.textEntryFieldWidth),
            suggestion.heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            suggestionBottom,
            done.trailingAnchor.constraint(equalTo: trailingAnchor),
            done.widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorButtonWidth),
            done.heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            doneBottom
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
