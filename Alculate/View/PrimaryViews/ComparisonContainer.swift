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
    let header = ComparisonHeader()
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
        addObjectsToView()
        backgroundColor = .blue
        constraints()
    }
    
    //MARK: - Add Objects
    func addObjectsToView() {
        addSubview(header)
        addSubview(table)
    }

    //MARK: - Constraints
    func constraints() {
        headerConstraints()
        tableConstraints()
    }
    
    //MARK: - Settings
    
    
    
    //MARK: - Functions
    func updateHeight(for table: String) {
        
    }
    
    func updateContentSize() {
        
    }
    
    func checkIfEmpty() {
        
    }
    
}
