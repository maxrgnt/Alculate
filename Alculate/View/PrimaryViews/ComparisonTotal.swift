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
    
    //MARK: Definitions
    // Constraints
    var height: NSLayoutConstraint!
    // Objects
    let total     = UILabel()
    let spent     = UILabel()
    let spentUnit = UILabel()
    let shots     = UILabel()
    let shotUnit  = UILabel()
    
    //MARK: Initialization
    init() {
        // Initialize frame of view
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setup() {
        alpha = 0.0
        objectSettings()
        addObjectsToView()
        constraints()
    }
    
    //MARK: Add Objects
    func addObjectsToView() {
        for obj in [total,spent,spentUnit,shots,shotUnit] {
            addSubview(obj)
        }
    }

    //MARK: Constraints
    func constraints() {
        totalConstraints()
        spentConstraints()
        spentUnitConstraints()
        shotsConstraints()
        shotUnitConstraints()
    }
    
    //MARK: Settings
    func objectSettings() {
        totalSettings()
        spentSettings()
        spentUnitSettings()
        shotsSettings()
        shotUnitSettings()
    }
    
    func totalSettings() {
        total.textAlignment = .left
        total.text          = Constants.Total.main
        total.font          = UI.Font.Comparison.total
        total.textColor     = UI.Color.Font.comparisonTotal
    }
    
    func spentSettings() {
        spent.textAlignment = .right
        spent.font          = UI.Font.Comparison.totalStat
        spent.textColor     = UI.Color.Font.comparisonTotal
    }
    
    func spentUnitSettings() {
        spentUnit.textAlignment = .right
        spentUnit.text          = Constants.Total.spentUnit
        spentUnit.font          = UI.Font.Comparison.totalUnit
        spentUnit.textColor     = UI.Color.Font.comparisonTotal
    }
    
    func shotsSettings() {
        shots.textAlignment = .right
        shots.font          = UI.Font.Comparison.totalStat
        shots.textColor     = UI.Color.Font.comparisonTotal
    }
    
    func shotUnitSettings() {
        shotUnit.textAlignment = .right
        shotUnit.text          = Constants.Total.shotUnit
        shotUnit.font          = UI.Font.Comparison.totalUnit
        shotUnit.textColor     = UI.Color.Font.comparisonTotal
    }
    
}
