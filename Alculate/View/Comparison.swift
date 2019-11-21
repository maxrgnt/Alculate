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
        constraints(anchorTo: anchorView)
    }
    
    func updateTable() {
        self.layoutIfNeeded()
        let newTableHeight = UI.Sizing.Height.comparisonRow * CGFloat(table.listForThisTable().count) + UI.Sizing.Radii.comparison
        height.constant = UI.Sizing.Height.comparisonHeader + newTableHeight
        table.height.constant = newTableHeight
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseInOut
            , animations: ({
                self.layoutIfNeeded()
            }), completion: { (completed) in
                // pass
        })
    }
    
    // MARK: - NSLayoutConstraints
    func constraints(anchorTo anchorView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        height = heightAnchor.constraint(equalToConstant: UI.Sizing.Height.comparison)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.Padding.comparison),
            widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparison),
            height,
            topAnchor.constraint(equalTo: anchorView.bottomAnchor, constant: UI.Sizing.Padding.comparison)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



