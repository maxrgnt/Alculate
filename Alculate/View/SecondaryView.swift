//
//  SecondaryView.swift
//  Alculate
//
//  Created by Max Sergent on 12/1/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class SecondaryView: UIView {
    
    //MARK: - Definitions
    // Objects
    let tableHeader = UILabel()
    var table = SavedABVTable()
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
        print("init secondary")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        addObjectsToView()
        constraints()
    }
    
    func addObjectsToView() {
        addSubview(tableHeader)
        addSubview(table)
    }
    
    func constraints() {
        tableHeaderConstraints()
        tableConstraints()
    }
    
    //MARK: - Animations

    
}
