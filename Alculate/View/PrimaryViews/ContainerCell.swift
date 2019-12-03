//
//  ContainerCell.swift
//  Alculate
//
//  Created by Max Sergent on 12/1/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class ContainerCell: UITableViewCell {
  
    //MARK: Definitions
    // Objects
    let name = UILabel()
    let value = UILabel()
    let valueUnit = UILabel()
    let effect = UILabel()
    let effectUnit = UILabel()
    // Variables
    var needsConstraints = true
    
    //MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "ContainerCell")
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    //MARK: Setup
    func setup() {
        selectionStyle = .none
        backgroundColor = .clear

        let border = CALayer()
        border.backgroundColor = UI.Color.Border.comparisonCell.cgColor
        let borderHeight = UI.Sizing.Comparison.separator
        let rowHeight = UI.Sizing.Comparison.Row.height
        let rowWidth = UI.Sizing.Comparison.Scroll.width
        let leadingAnchor = UI.Sizing.Comparison.border
        border.frame = CGRect(x: leadingAnchor, y: rowHeight - borderHeight, width: rowWidth - leadingAnchor, height: borderHeight)
        contentView.layer.addSublayer(border)
        
        nameSettings()
        valueEffectSettings()
        unitSettings()
        
        addObjectsToView()
        
        constraints()
    }

    //MARK: Add Objects
    func addObjectsToView() {
        for obj in [name,value,valueUnit,effect,effectUnit] {
            addSubview(obj)
        }
    }
    
    //MARK: Constraints
    func constraints() {
        nameConstraints()
        valueConstraints()
        valueUnitConstraints()
        effectConstraints()
        effectUnitConstraints()
    }
    
    //MARK: Settings
    func nameSettings() {
        name.textColor = UI.Color.Font.comparisonCell
        name.textAlignment = .left
        name.font = UI.Font.Comparison.row
    }
    
    func valueEffectSettings() {
        for obj in [value,effect] {
            obj.textColor = UI.Color.Font.comparisonCell
            obj.textAlignment = .right
            obj.font = UI.Font.Comparison.row
        }
    }
    
    func unitSettings() {
        for obj in [valueUnit,effectUnit] {
            obj.textColor = UI.Color.Font.comparisonCell
            obj.textAlignment = .right
            obj.font = UI.Font.Comparison.rowUnit
        }
        valueUnit.text = "per shot"
        effectUnit.text = "shots"
    }
    
    // MARK: Label Setter
    func setLabels(with info: (name: String, abv: String, size: String, price: String)) {
        name.text = "\(info.name.capitalized)"
        // get the unitForSize by dropping the first part of string
        // using length of string minus the last two characters (oz or ml) ex. 24ml
        let sizeUnit = info.size.dropFirst(info.size.count-2)
        // get the size by dropping last two characters (oz or ml) ex. 24ml
        let size = info.size.dropLast(2)
        var correctedSize = Double(size)!
        // if unitForSize is ml, need to convert to oz for calculations
        if sizeUnit == "ml" {
            // convert ml size to ounces using ratio of ml per oz
            correctedSize = correctedSize/29.5735296875
        }
        // calculate the effectiveness
        let abvAsDecimal = (0.01)*Double(info.abv)!
        let standardShot = (0.4 /*ABV*/ * 1.5 /*oz*/) // = 0.6
        let calcEffect = (abvAsDecimal*correctedSize)/standardShot
        // calculate the value
        let calcValue = Double(info.price)!/calcEffect
        value.text = "$"+String(format: "%.2f", calcValue)
        effect.text = String(format: "%.1f", calcEffect)
    }
        
}
