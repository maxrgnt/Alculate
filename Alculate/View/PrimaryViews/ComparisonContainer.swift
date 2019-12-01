//
//  ComparisonPiece.swift
//  Alculate
//
//  Created by Max Sergent on 11/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

class ComparisonContainer: UIScrollView {
    
    //MARK: - Definitions
    // Constraints
    var height: NSLayoutConstraint!
    // Objects
    let header = ContainerHeader()
    let table = ComparisonTable()
    // Variables
    var type = ""
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
        print("init copmarisonAll")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup(forType id: String) {
        type = id
        backgroundColor = UI.Color.Comparison.background
        layer.borderColor = UI.Color.Comparison.border.cgColor
        layer.borderWidth = UI.Sizing.Comparison.border
        roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.Comparison.radii)
        
        addObjectsToView()
        
        constraints()
    }
    
    //MARK: - Add Objects
    func addObjectsToView() {
        addSubview(header)
        header.setup(forType: type)
        addSubview(table)
    }

    //MARK: - Constraints
    func constraints() {
        headerConstraints()
        tableConstraints()
    }
    
    //MARK: - Settings
    
    
    
    //MARK: - Functions

    
}
