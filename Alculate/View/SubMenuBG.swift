//
//  SubMenuBG.swift
//  Alculate
//
//  Created by Max Sergent on 11/15/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class SubMenuBG: UIView {
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        backgroundColor = UI.Color.alculatePurpleDarkest
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.subMenuHeight+UI.Sizing.subMenuBounceBuffer),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            bottomAnchor.constraint(equalTo: ViewController.bottomAnchor)
        ])
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
