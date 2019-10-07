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
        let viewOrigin = CGPoint(x: 0, y: 0)
        let viewSize = CGSize(width: UI.Sizing.width, height: UI.Sizing.statusBar.height)
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect(origin: viewOrigin, size: viewSize))
        //
        backgroundColor = UI.Color.alculatePurpleDark
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
