//
//  ComparisonHeader.swift
//  Alculate
//
//  Created by Max Sergent on 11/20/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit

protocol ComparisonHeaderDelegate {
    // called when user taps container or delete button
//    func reloadTable(table: String, realculate: Bool)
//    func makeDeletable(_ paramDeletable: Bool, lists: String)
//    func editComparison(type: String, name: String, abv: String, size: String, price: String)
//    func alculate()
}

class ComparisonHeader: UIView {

    // Delegate object
    var delegate : ComparisonHeaderDelegate!

    // Objects
    var type = UIButton()
    var add = UIButton()
    
    override init (frame: CGRect) {
        // Initialize views frame prior to setting constraints
        super.init(frame: frame)
    }
    
    // MARK: - View/Object Settings
    func build(forType alcoholType: String, anchorTo anchorView: UIView) {
        backgroundColor = UI.Color.Background.comparisonHeader
        
        for obj in [type, add] {
            addSubview(obj)
        }
        type.contentVerticalAlignment = .bottom
        type.contentHorizontalAlignment = .left
        type.setTitle(alcoholType, for: .normal)
        type.titleLabel?.font = UI.Font.Header.comparisonType!
        add.contentVerticalAlignment = .center
        add.contentHorizontalAlignment = .right
        add.setTitle("+", for: .normal)
        add.titleLabel?.font = UI.Font.Header.comparisonAdd!
        
        constraints(anchorTo: anchorView)
    }
    
    // MARK: - NSLayoutConstraints
    func constraints(anchorTo anchorView: UIView) {
        for obj in [self, type, add] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: anchorView.leadingAnchor),
            widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparisonHeader),
            heightAnchor.constraint(equalToConstant: UI.Sizing.Height.comparisonHeader),
            topAnchor.constraint(equalTo: anchorView.topAnchor),
            type.leadingAnchor.constraint(equalTo: anchorView.leadingAnchor, constant: UI.Sizing.Padding.comparisonHeader/2),
            type.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparisonType),
            type.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.comparisonHeader),
            type.centerYAnchor.constraint(equalTo: centerYAnchor),
            add.trailingAnchor.constraint(equalTo: anchorView.trailingAnchor, constant: -UI.Sizing.Padding.comparisonHeader/2),
            add.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.comparisonAdd),
            add.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.comparisonHeader),
            add.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



