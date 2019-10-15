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
    
    // Objects
    let exit = UIButton()
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
        let titles = ["exit","back","next"]
        let alignments: [UIControl.ContentHorizontalAlignment] = [.left,.right,.right]
        for (i, button) in [exit,backward,forward].enumerated() {
            button.tag = i-1
            addSubview(button)
            button.backgroundColor = .clear
            button.setTitle(titles[i], for: .normal)
            button.setTitleColor(UI.Color.softWhite, for: .normal)
            button.contentHorizontalAlignment = alignments[i]
        }
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [exit,forward,backward] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        TextNavigator.bottom = bottomAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorWidth),
            heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.objectPadding),
            TextNavigator.bottom,
            exit.leadingAnchor.constraint(equalTo: leadingAnchor),
            exit.widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorWidth/3),
            exit.heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            exit.bottomAnchor.constraint(equalTo: bottomAnchor),
            forward.trailingAnchor.constraint(equalTo: trailingAnchor),
            forward.widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorWidth/4),
            forward.heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            forward.bottomAnchor.constraint(equalTo: bottomAnchor),
            backward.trailingAnchor.constraint(equalTo: forward.leadingAnchor),
            backward.widthAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorWidth/4),
            backward.heightAnchor.constraint(equalToConstant: UI.Sizing.textNavigatorHeight),
            backward.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
