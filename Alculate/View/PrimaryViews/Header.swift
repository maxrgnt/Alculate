//
//  Header.swift
//  Alculate
//
//  Created by Max Sergent on 11/29/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Header: UIView {
    
    //MARK: - Definitions
    // Constraints
    var height: NSLayoutConstraint!
    // Objects
    let statusBar = StatusBar()
    let appName = UILabel()
    let value = SummaryCell()
    let effect = SummaryCell()
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
        backgroundColor = UI.Color.Header.background
        print("init header2")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        addObjectsToView()
        roundCorners(corners: [.bottomLeft,.bottomRight], radius: UI.Sizing.Radii.header)
        appNameSettings()
        value.setup(to: "left")
        value.category.text = "Highest Value"
        value.statUnit.text = "per shot"
        effect.setup(to: "right")
        effect.category.text = "Most Effective"
        effect.statUnit.text = "shots"
        constraints()
    }
    
    func addObjectsToView() {
        for obj in [effect,value,appName,statusBar] {
            addSubview(obj)
        }
    }

    func constraints() {
        statusBarConstraints()
        appNameConstraints()
        valueConstraints()
        effectConstraints()
    }
    
    func appNameSettings() {
        appName.backgroundColor = backgroundColor
        appName.textColor = UI.Color.Header.font
        appName.font = UI.Font.Header.appName
        appName.textAlignment = .center
        appName.text = "Alculate"
    }
    
}
