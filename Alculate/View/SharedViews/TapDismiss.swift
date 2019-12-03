//
//  TapDismiss.swift
//  Alculate
//
//  Created by Max Sergent on 10/24/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TapDismiss: UIView {
    
    //MARK: - Definitions
    // Constraints
    static var dismissTop: NSLayoutConstraint!
    // Objects
    static let dismiss = UIButton()
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        backgroundColor = .clear

        addSubview(TapDismiss.dismiss)

        constraints()
    }
    
    //MARK: Constraints
    func constraints() {
        tapDismissConstraints()
    }

    
}
