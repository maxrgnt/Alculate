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
    var backwardBottom = NSLayoutConstraint()
    
    // Objects
    let backward = UIButton()
    let forward = UIButton()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        backgroundColor = .clear
        clipsToBounds = true
        //
        let titles = ["back","next"]
        let alignments: [UIControl.ContentHorizontalAlignment] = [.right,.right]
//        let alignments: [UIControl.ContentHorizontalAlignment] = [.center,.center,.center]
        for (i, button) in [backward,forward].enumerated() {
            button.tag = (i==0) ? -1 : 1
            addSubview(button)
            button.backgroundColor = .clear
            button.setTitle(titles[i], for: .normal)
            button.setTitleColor(UI.Color.softWhite, for: .normal)
            button.contentHorizontalAlignment = alignments[i]
        }
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [forward,backward] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        TextNavigator.bottom = bottomAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: 0)
        backwardBottom = backward.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorWidth),
            heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.objectPadding),
            TextNavigator.bottom,
            forward.trailingAnchor.constraint(equalTo: trailingAnchor),
            forward.widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorWidth/4),
            forward.heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            forward.bottomAnchor.constraint(equalTo: bottomAnchor),
            backward.trailingAnchor.constraint(equalTo: forward.leadingAnchor),
            backward.widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorWidth/4),
            backward.heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            backwardBottom
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
