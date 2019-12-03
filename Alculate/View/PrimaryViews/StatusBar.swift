//
//  StatusBar.swift
//  Alculate
//
//  Created by Max Sergent on 10/7/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class StatusBar: UIView {
    
    //MARK: Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
        backgroundColor = UI.Color.Header.background 
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
