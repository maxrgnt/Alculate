//
//  ComparisonAll.swift
//  Alculate
//
//  Created by Max Sergent on 11/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

class ComparisonScroll: UIScrollView {
    
    //MARK: - Definitions
    // Constraints
    var height: NSLayoutConstraint!
    // Objects
    let beer = ComparisonPiece()
    let liquor = ComparisonPiece()
    let wine = ComparisonPiece()
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
        print("init comparisonScroll")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        
        isScrollEnabled = true
        alwaysBounceVertical = true
        alwaysBounceHorizontal = false
        showsVerticalScrollIndicator = false
        contentSize.height = UI.Sizing.ComparisonScroll.heightEmpty
        
        addObjectsToView()
        
        constraints()
    }
    
    //MARK: - Add Objects
    func addObjectsToView() {
        for obj in [beer,liquor,wine] {
            addSubview(obj)
            obj.setup() 
        }
    }

    //MARK: - Constraints
    func constraints() {
        beerConstraints()
        liquorConstraints()
        wineConstraints()
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
