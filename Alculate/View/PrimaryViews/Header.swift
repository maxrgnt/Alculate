//
//  Header.swift
//  Alculate
//
//  Created by Max Sergent on 11/29/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Header: UIView {
    
    //MARK: Definitions
    // Constraints
    var height: NSLayoutConstraint!
    // Objects
    let statusBar = StatusBar()
    let appName   = UILabel()
    let value     = SummaryCell()
    let effect    = SummaryCell()
    
    //MARK: Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
        backgroundColor = UI.Color.Header.background
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setup() {
        addObjectsToView()
        roundCorners(corners: [.bottomLeft,.bottomRight], radius: UI.Sizing.Header.radii)
        appNameSettings()
        value.setup(to: "left")
        effect.setup(to: "right")
        value.category.text  = Constants.Header.valueCategory
        value.statUnit.text  = Constants.Header.valueUnit
        effect.category.text = Constants.Header.effectCategory
        effect.statUnit.text = Constants.Header.effectUnit
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
        appName.textColor       = UI.Color.Header.font
        appName.font            = UI.Font.Header.appName
        appName.textAlignment   = .center
        appName.text            = Constants.Header.appName
    }
    
}
