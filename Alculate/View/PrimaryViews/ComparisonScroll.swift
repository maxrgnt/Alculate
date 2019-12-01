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
    let beer = ComparisonContainer()
    let liquor = ComparisonContainer()
    let wine = ComparisonContainer()
    var tables: [ComparisonContainer] = []
    
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
        
        tables = [beer,liquor,wine]
        
        isScrollEnabled = true
        alwaysBounceVertical = true
        alwaysBounceHorizontal = false
        showsVerticalScrollIndicator = false
        contentSize.height = UI.Sizing.Comparison.Scroll.heightEmpty
        
        addObjectsToView()
        
        constraints()
    }
    
    //MARK: - Add Objects
    func addObjectsToView() {
        for (i, obj) in tables.enumerated() {
            addSubview(obj)
            obj.setup(forType: Data.IDs[i])
        }
    }

    //MARK: - Constraints
    func constraints() {
        beerConstraints()
        liquorConstraints()
        wineConstraints()
        for obj in Data.IDs {
            updateHeight(for: obj, animated: false)
        }
    }
    
    //MARK: - Settings
    
    
    
    //MARK: - Functions
    func updateHeight(for container: String, animated: Bool? = true) {
        var new: CGFloat = 0.0
        for (i, id) in Data.IDs.enumerated() {
            if container == id {
                // set new height to the header + however many rows
                new = UI.Sizing.Comparison.Header.height + CGFloat(Data.lists[i].count) * UI.Sizing.Comparison.Row.height
                // add to the new height for the rounded radii at bottom and border
                new += UI.Sizing.Comparison.radii + UI.Sizing.Comparison.border*2
                // only animate when necessary (not on app load)
                if animated! {
                    UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut
                        , animations: ({
                            self.tables[i].height.constant = new
                            self.layoutIfNeeded()
                        }), completion: { (completed) in
                            // pass
                    })
                }
                else {
                    tables[i].height.constant = new
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func updateContentSize() {
        
    }
    
    func checkIfEmpty() {
        
    }
    
}
