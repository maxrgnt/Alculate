//
//  Header.swift
//  Alculate
//
//  Created by Max Sergent on 11/21/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Header: UIView {
     
    // Objects
    let appName = UILabel()
    var summary = Summary()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    // MARK: - View/Object Settings
    func build(anchorTo anchorView: UIView) {
        clipsToBounds = false
        backgroundColor = UI.Color.bgDarkest
        
        roundCorners(corners: [.bottomLeft,.bottomRight], radius: UI.Sizing.Radii.header)

        addSubview(appName)
        appName.textColor = UI.Color.fontWhite
        appName.font = UI.Font.headerFont
        appName.textAlignment = .center
        appName.text = "Alculate"
        
        addSubview(summary)
        summary.build(anchorTo: appName)
        
        constraints(anchorTo: anchorView)
    }
    
    // MARK: - NSLayoutConstraints
    func constraints(anchorTo anchorView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        appName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.Width.header),
            heightAnchor.constraint(equalToConstant: UI.Sizing.Height.header),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            topAnchor.constraint(equalTo: anchorView.topAnchor),
            appName.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.header),
            appName.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.headerAppName),
            appName.topAnchor.constraint(equalTo: anchorView.topAnchor, constant: UI.Sizing.statusBar.height),
            appName.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
