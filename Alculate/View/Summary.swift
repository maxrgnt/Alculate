//
//  Summary.swift
//  Alculate
//
//  Created by Max Sergent on 11/21/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Summary: UIView {
    
    // Constraints
    var top: NSLayoutConstraint!
    
    // Objects
    var value = SummaryCell()
    var effect = SummaryCell()
    var leftPadding = UIView()
    var rightPadding = UIView()

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    // MARK: - View/Object Settings
    func build(anchorTo anchorView: UIView) {
        backgroundColor = UI.Color.Background.summary
        clipsToBounds = true
        
        for (topLinePiece) in [value,effect] {
            addSubview(topLinePiece)
        }
        
        for obj in [leftPadding,rightPadding] {
            addSubview(obj)
            obj.backgroundColor = backgroundColor
        }
                
        value.build(alignText: .left, leadingAnchors: 0, anchorTo: self)
        value.category.text = "Value"
        value.statUnit.text = "per shot"
        
        effect.build(alignText: .right, leadingAnchors: 1, anchorTo: self)
        effect.category.text = "Effect"
        effect.statUnit.text = "shots"
        
        constraints(anchorTo: anchorView)
        
    }
    
    // MARK: - NSLayoutConstraints
    func constraints(anchorTo anchorView: UIView) {
        for obj in [self,leftPadding,rightPadding] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        top = topAnchor.constraint(equalTo: anchorView.bottomAnchor)
        NSLayoutConstraint.activate([
            top,
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.Height.summary),
            leadingAnchor.constraint(equalTo: anchorView.leadingAnchor),
            leftPadding.widthAnchor.constraint(equalToConstant: UI.Sizing.Padding.summary),
            leftPadding.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.summary),
            leftPadding.topAnchor.constraint(equalTo: topAnchor),
            leftPadding.leadingAnchor.constraint(equalTo: leadingAnchor),
            rightPadding.widthAnchor.constraint(equalToConstant: UI.Sizing.Padding.summary),
            rightPadding.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.summary),
            rightPadding.topAnchor.constraint(equalTo: topAnchor),
            rightPadding.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
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
