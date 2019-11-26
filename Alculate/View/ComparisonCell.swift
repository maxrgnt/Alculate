//
//  ComparisonCell.swift
//  Alculate
//
//  Created by Max Sergent on 11/20/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

// Protocol to communicate with tableview/viewcontroller
protocol ComparisonCellDelegate: AnyObject {
//    func delegateCell(animate: Bool, forCell: OldComparisonCell)
//    func delegateRemove(forCell: OldComparisonCell)
//    func delegatePopulate(forCell: OldComparisonCell)
}

class ComparisonCell: UITableViewCell {
  
    // Delegate object for Protocol above
    var delegate: ComparisonCellDelegate?
    
    // Objects
    let name = UILabel()
    let value = UILabel()
    let valueUnit = UILabel()
    let effect = UILabel()
    let effectUnit = UILabel()
    
    // Variables
    var needsConstraints = true
    
    // MARK: - View/Object Settings
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Initialize views frame prior to setting constraints
        super.init(style: style, reuseIdentifier: "ComparisonCell")
        selectionStyle = .none
        backgroundColor = .clear

        let border = CALayer()
        border.backgroundColor = UI.Color.Border.comparisonCell.cgColor
        let borderHeight = UI.Sizing.Border.comparisonRow
        let rowHeight = UI.Sizing.Height.comparisonRow
        let rowWidth = UI.Sizing.Width.comparison
        let leadingAnchor = UI.Sizing.Border.comparison
        border.frame = CGRect(x: leadingAnchor, y: rowHeight - borderHeight, width: rowWidth - leadingAnchor, height: borderHeight)
        contentView.layer.addSublayer(border)
        
        addSubview(name)
        name.textColor = UI.Color.Font.comparisonCell
        name.textAlignment = .left
        name.font = UI.Font.Comparison.row
        
        for obj in [value,effect] {
            addSubview(obj)
            obj.textColor = UI.Color.Font.comparisonCell
            obj.textAlignment = .right
            obj.font = UI.Font.Comparison.row
        }
        
        for obj in [valueUnit,effectUnit] {
            addSubview(obj)
            obj.textColor = UI.Color.Font.comparisonCell
            obj.textAlignment = .right
            obj.font = UI.Font.Comparison.rowUnit
        }
        
        valueUnit.text = "per shot"
        effectUnit.text = "shots"
        
        constraints()
    }
    
    // MARK: - Label Setter
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
        
    func constraints() {
        // MARK: - NSLayoutConstraints
        for obj in [name,value,valueUnit,effect,effectUnit] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            name.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparisonRowName),
            name.heightAnchor.constraint(equalTo: heightAnchor, constant: -UI.Sizing.Border.comparisonRow),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.Padding.comparisonHeader),
            name.centerYAnchor.constraint(equalTo: centerYAnchor),
            value.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparisonRowValue),
            value.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.comparisonRowStat),
            value.leadingAnchor.constraint(equalTo: name.trailingAnchor),
            value.topAnchor.constraint(equalTo: topAnchor),
            valueUnit.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparisonRowValue),
            valueUnit.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.comparisonRowUnit),
            valueUnit.leadingAnchor.constraint(equalTo: name.trailingAnchor),
            valueUnit.topAnchor.constraint(equalTo: value.bottomAnchor, constant: -UI.Sizing.Height.comparisonRowUnit/3),
            effect.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparisonRowEffect),
            effect.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.comparisonRowStat),
            effect.leadingAnchor.constraint(equalTo: value.trailingAnchor),
            effect.topAnchor.constraint(equalTo: topAnchor),
            effectUnit.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparisonRowValue),
            effectUnit.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.comparisonRowUnit),
            effectUnit.leadingAnchor.constraint(equalTo: value.trailingAnchor),
            effectUnit.topAnchor.constraint(equalTo: effect.bottomAnchor, constant: -UI.Sizing.Height.comparisonRowUnit/3)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
