//
//  ComparisonTotal.swift
//  Alculate
//
//  Created by Max Sergent on 12/3/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

class ComparisonTotal: UIView {
    
    //MARK: - Definitions
    // Constraints
    var height: NSLayoutConstraint!
    // Objects
    let total = UILabel()
    let spent = UILabel()
    let shots = UILabel()
    let shotUnit = UILabel()
    
    //MARK: - Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {

        objectSettings()
        
        addObjectsToView()
        
        constraints()
    }
    
    //MARK: - Add Objects
    func addObjectsToView() {
        for obj in [total,spent,shots,shotUnit] {
            addSubview(obj)
        }
    }

    //MARK: - Constraints
    func constraints() {
        totalConstraints()
        spentConstraints()
        shotsConstraints()
        shotUnitConstraints()
    }
    
    //MARK: - Settings
    func objectSettings() {
        totalSettings()
        spentSettings()
        shotsSettings()
        shotUnitSettings()
    }
    
    func totalSettings() {
        total.textAlignment = .left
        total.text = "Total:"
        total.font = UI.Font.Comparison.total
        total.textColor = UI.Color.Font.comparisonTotal
    }
    
    func spentSettings() {
        spent.textAlignment = .right
        spent.text = "$5.00"
        spent.font = UI.Font.Comparison.totalStat
        spent.textColor = UI.Color.Font.comparisonTotal
    }
    
    func shotsSettings() {
        shots.textAlignment = .right
        shots.text = "6.7"
        shots.font = UI.Font.Comparison.totalStat
        shots.textColor = UI.Color.Font.comparisonTotal
    }
    
    func shotUnitSettings() {
        shotUnit.textAlignment = .right
        shotUnit.text = "shots"
        shotUnit.font = UI.Font.Comparison.totalUnit
        shotUnit.textColor = UI.Color.Font.comparisonTotal
    }
    
    //MARK: - Functions

    
}
