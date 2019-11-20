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

    // Variables
    var type = ""
    
    override init (frame: CGRect) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame)
    }
    
    func build(forType alcoholID: String, anchorTo anchorView: UIView) {
        // MARK: - View/Object Settings
        type = alcoholID
        backgroundColor = UI.Color.Background.comparison
        layer.borderColor = UI.Color.Border.comparison.cgColor
        layer.borderWidth = UI.Sizing.Border.comparison
        roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.Radii.comparison)
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor, constant: UI.Sizing.Padding.comparison),
            widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparison),
            heightAnchor.constraint(equalToConstant: UI.Sizing.Height.comparison),
            topAnchor.constraint(equalTo: anchorView.bottomAnchor, constant: UI.Sizing.Padding.comparison)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



