//
//  Header.swift
//  Alculate
//
//  Created by Max Sergent on 11/21/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Header: UIView {
     
    // Constraints
    var height: NSLayoutConstraint!
    
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
        backgroundColor = UI.Color.Background.header
        
        roundCorners(corners: [.bottomLeft,.bottomRight], radius: UI.Sizing.Radii.header)

        addSubview(appName)
        appName.backgroundColor = backgroundColor
        appName.textColor = UI.Color.fontWhite
        appName.font = UI.Font.headerFont
        appName.textAlignment = .center
        appName.text = "Alculate"
        
        self.insertSubview(summary, at: 0)
        summary.build(anchorTo: appName)
        
        constraints(anchorTo: anchorView)
        setAppNameConstraints()
    }
    
    // MARK: - NSLayoutConstraints
    func constraints(anchorTo anchorView: UIView) {
        for obj in [self] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        height = heightAnchor.constraint(equalToConstant: UI.Sizing.Height.headerMinimized)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.Width.header),
            height,
            leadingAnchor.constraint(equalTo: anchorView.leadingAnchor),
            topAnchor.constraint(equalTo: anchorView.bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Header {
    
    private func setAppNameConstraints() {
        appName.translatesAutoresizingMaskIntoConstraints                                           = false
        appName.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.header).isActive            = true
        appName.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.headerAppName).isActive   = true
        appName.topAnchor.constraint(equalTo: topAnchor).isActive                                   = true
        appName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                           = true
    }
    
}
