//
//  SummaryBG.swift
//  Alculate
//
//  Created by Max Sergent on 11/19/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class SummaryBG: UIView {
    
    // Constraints
    var top: NSLayoutConstraint!
    
    // Objects
    var valueSummary = Summary()
    var effectSummary = Summary()

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        backgroundColor = UI.Color.bgDarkest
        clipsToBounds = true
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        top = topAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: -UI.Sizing.subMenuHeight) // UI.Sizing.topLineTop)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight),
            top,
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor)
        ])
        
        // Object settings
        let categories = ["Value","Effect"]
        let valueDescriptions = ["per shot","shots"]
        let topLineIcons = ["",""] // ["value","effect"]
        let alignments = [.left,.right] as [NSTextAlignment]
        for (i, topLinePiece) in [valueSummary,effectSummary].enumerated() {
            addSubview(topLinePiece)
            topLinePiece.build(iconName: topLineIcons[i], alignText: alignments[i], leadingAnchors: i)
            topLinePiece.category.text = categories[i]
            topLinePiece.valueDescription.text = valueDescriptions[i]
        }
    }
    
    func moveTopAnchor(to newConstant: CGFloat) {
        if top != nil {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut
                , animations: ({
                    self.top.constant = newConstant
                    self.layoutIfNeeded()
                }), completion: { (completed) in
                    // pass
                }
            )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
