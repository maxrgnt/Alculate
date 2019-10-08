//
//  StatusBar.swift
//  Alculate
//
//  Created by Max Sergent on 10/7/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class StatusBar: UIView {
    
    init() {
        // Set view origin (top left of screen)
        let viewOrigin = CGPoint(x: 0, y: 0)
        // Set view size (height of the status bar)
        let viewSize = CGSize(width: UI.Sizing.width, height: UI.Sizing.statusBar.height)
        // Initialize frame of view
        super.init(frame: CGRect(origin: viewOrigin, size: viewSize))
        // Set background color you want to mask the status bar as
        backgroundColor = UI.Color.alculatePurpleDark
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
