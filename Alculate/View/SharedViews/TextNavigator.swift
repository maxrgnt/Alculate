//
//  TextNavigation.swift
//  Alculate
//
//  Created by Max Sergent on 10/14/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TextNavigator: UIView {
         
    //MARK: Definitions
    // Constraints
    static var bottom: NSLayoutConstraint!
    var forwardBottom: NSLayoutConstraint!
    var backwardBottom: NSLayoutConstraint!
    var suggestionBottom: NSLayoutConstraint!
    var doneBottom: NSLayoutConstraint!
    // Objects
    let suggestion = UIButton()
    let backward = UIButton()
    let forward = UIButton()
    let done = UIButton()
    
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
        backgroundColor = .clear
        clipsToBounds = true
        
        objectSettings()
        
        constraints()
    }
    
    //MARK: Object Settings
    func objectSettings() {
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
        addSubview(suggestion)
        suggestion.tag = 2
        suggestion.backgroundColor = .clear
        suggestion.titleLabel?.font = UI.Font.TextEntry.navigator
        suggestion.setTitle("Use 'Coors Light'", for: .normal)
        suggestion.setTitleColor(UI.Color.Font.standard, for: .normal)
        suggestion.contentHorizontalAlignment = .left
    }
    
    //MARK: Constraints
    func constraints() {
        forwardConstraints()
        backwardConstraints()
        doneConstraints()
        suggestionConstraints()
    }
}
