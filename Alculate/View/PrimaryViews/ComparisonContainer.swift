//
//  ComparisonContainer.swift
//  Alculate
//
//  Created by Max Sergent on 11/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

class ComparisonContainer: UIScrollView {
    
    //MARK: Definitions
    // Constraints
    var height: NSLayoutConstraint!
    var top:    NSLayoutConstraint!
    // Objects
    let header = ContainerHeader()
    let table  = ContainerTable()
    // Variables
    var type = ""
    
    //MARK: Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setup(forType id: String) {
        type              = id
        clipsToBounds     = true
        backgroundColor   = UI.Color.Comparison.background
        layer.borderColor = UI.Color.Comparison.border.cgColor
        layer.borderWidth = UI.Sizing.Comparison.border
        roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.Comparison.radii)
        addObjectsToView()
        constraints()
    }
    
    //MARK: Add Objects
    func addObjectsToView() {
        addSubview(header)
        header.setup(forType: type)
        addSubview(table)
        table.setup(forType: type)
    }

    //MARK: Constraints
    func constraints() {
        headerConstraints()
        tableConstraints()
    }
    
}
