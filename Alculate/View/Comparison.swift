//
//  Comparison.swift
//  Alculate
//
//  Created by Max Sergent on 11/20/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

protocol ComparisonDelegate {
    // called when user taps container or delete button
//    func reloadTable(table: String, realculate: Bool)
//    func makeDeletable(_ paramDeletable: Bool, lists: String)
//    func editComparison(type: String, name: String, abv: String, size: String, price: String)
//    func alculate()
}

class Comparison: UIView {

    // Delegate object
    var delegate : ComparisonDelegate!

    // Constraints
    var height: NSLayoutConstraint!
    
    // Objects
    var header = ComparisonHeader()
    var table = ComparisonTable()
    var clear = UIButton()
    
    // Variables
    var type = ""
    
    override init (frame: CGRect) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame)
    }
    
    // MARK: - View/Object Settings
    func build(forType alcoholID: String, anchorTo anchorView: UIView) {
        type = alcoholID
        backgroundColor = UI.Color.Background.comparison
        layer.borderColor = UI.Color.Border.comparison.cgColor
        layer.borderWidth = UI.Sizing.Border.comparison
        roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.Radii.comparison)
        addSubview(header)
        header.build(forType: alcoholID, anchorTo: self)
        addSubview(table)
        table.build(forType: alcoholID, anchorTo: self)
//        addSubview(clear)
//        clear.backgroundColor = .clear
//        clear.setTitleColor(UI.Color.Border.comparison, for: .normal)
//        clear.setTitle("clear", for: .normal)
//        clear.titleLabel?.font = UI.Font.Comparison.row
//        clear.contentVerticalAlignment = .center
        constraints(anchorTo: anchorView)
    }
        
    // MARK: - NSLayoutConstraints
    func constraints(anchorTo anchorView: UIView) {
        var newConstant: CGFloat = 0.0
        var newRadius: CGFloat = 0.0
        for obj in [self,clear] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        let lists = [Data.beerList, Data.liquorList, Data.wineList]
        for (i, id) in [Data.beerListID, Data.liquorListID, Data.wineListID].enumerated() {
            if type == id {
                newConstant = UI.Sizing.Height.comparisonHeader + CGFloat(lists[i].count) * UI.Sizing.Height.comparisonRow
                newConstant = (lists[i].count == 0) ? newConstant : newConstant + UI.Sizing.Radii.comparison
                newRadius = (lists[i].count == 0) ? UI.Sizing.Radii.comparisonEmpty : UI.Sizing.Radii.comparison
            }
        }
        layer.cornerRadius = newRadius
        height = heightAnchor.constraint(equalToConstant: newConstant)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.Padding.comparison),
            widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparison),
            height,
            topAnchor.constraint(equalTo: anchorView.bottomAnchor, constant: UI.Sizing.Padding.comparison)
//            clear.centerXAnchor.constraint(equalTo: centerXAnchor),
//            clear.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparison),
//            clear.heightAnchor.constraint(equalToConstant: UI.Sizing.Padding.comparison),
//            clear.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



