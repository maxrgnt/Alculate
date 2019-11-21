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
        let rowWidth = UI.Sizing.Width.comparisonTable
        border.frame = CGRect(x: 0, y: rowHeight - borderHeight, width: rowWidth, height: borderHeight)
        contentView.layer.addSublayer(border)
        
        for obj in [name,value,valueUnit,effect,effectUnit] {
            addSubview(obj)
        }
        
        constraints()
    }
    
//    // MARK: - Label Setter
//    func setLabels(with info: (name: String, abv: String, size: String, price: String)) {
//        container.drinkName.text = "\(info.name.capitalized)"
//        // convert price to $X.00 format
////        let price = String(format: "%.2f", Double(info.price)!)
//        // get the unitForSize by dropping the first part of string
//        // using length of string minus the last two characters (oz or ml) ex. 24ml
//        let sizeUnit = info.size.dropFirst(info.size.count-2)
//        // get the size by dropping last two characters (oz or ml) ex. 24ml
//        let size = info.size.dropLast(2)
//        // set info using price and size piece
////        container.drinkInfo.text = "\(info.size.dropLast(2)) \(sizeUnit) | $\(price)"
//        var correctedSize = Double(size)!
//        // if unitForSize is ml, need to convert to oz for calculations
//        if sizeUnit == "ml" {
//            // convert ml size to ounces using ratio of ml per oz
//            correctedSize = correctedSize/29.5735296875
//        }
//        // calculate the effectiveness
//        let abvAsDecimal = (0.01)*Double(info.abv)!
//        let standardShot = (0.4 /*ABV*/ * 1.5 /*oz*/) // = 0.6
//        let effect = (abvAsDecimal*correctedSize)/standardShot
//        // calculate the value
//        let value = Double(info.price)!/effect
//        container.value.text = "$"+String(format: "%.2f", value)
//        container.effect.text = String(format: "%.1f", effect)
//    }
        
    func constraints() {
        // MARK: - NSLayoutConstraints
        for obj in [name,value,valueUnit,effect,effectUnit] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            name.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparisonTable),
            name.heightAnchor.constraint(equalTo: heightAnchor, constant: -UI.Sizing.Border.comparisonRow),
            name.leadingAnchor.constraint(equalTo: leadingAnchor),
            name.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
