//
//  TapDismiss.swift
//  Alculate
//
//  Created by Max Sergent on 10/24/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TapDismiss: UIView {
    
    // constraints
    static var dismissTop: NSLayoutConstraint!
    
    // objects
    static let dismiss = UIButton()
    
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
        // Set background color you want to mask the status bar as
        addSubview(TapDismiss.dismiss)
        backgroundColor = UI.Color.alculatePurpleDark
    }
    
    func build() {
        translatesAutoresizingMaskIntoConstraints = false
        TapDismiss.dismiss.translatesAutoresizingMaskIntoConstraints = false
        TapDismiss.dismissTop = self.topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.bounds.height)
        NSLayoutConstraint.activate([
            // View constraints
            bottomAnchor.constraint(equalTo: ViewController.bottomAnchor),
            TapDismiss.dismissTop,
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            trailingAnchor.constraint(equalTo: ViewController.trailingAnchor),
            TapDismiss.dismiss.widthAnchor.constraint(equalTo: widthAnchor),
            TapDismiss.dismiss.heightAnchor.constraint(equalTo: heightAnchor),
            TapDismiss.dismiss.leadingAnchor.constraint(equalTo: leadingAnchor),
            TapDismiss.dismiss.topAnchor.constraint(equalTo: topAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
