//
//  SummaryCell.swift
//  Alculate
//
//  Created by Max Sergent on 11/21/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class SummaryCell: UIView {
    
    // Constraints
    var nameWidth: NSLayoutConstraint!
    
    // Objects
    let category = UILabel()
    let name = UILabel()
    let stat = UILabel()
    let statUnit = UILabel()
    
    // Variables
    var calcFontWidth: CGFloat!
    var labelAnimation = false
    var leading: Int! = 0

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    // MARK: - View/Object Settings
    func build(alignText: NSTextAlignment, leadingAnchors: Int, anchorTo anchorView: UIView) {
        backgroundColor = UI.Color.Background.summary
        clipsToBounds = true
        for label in [category,name,stat,statUnit] {
            addSubview(label)
            label.textColor = UI.Color.fontWhite
            label.textAlignment = alignText
            label.alpha = 1.0
        }

        category.font = UI.Font.Summary.category
//        category.alpha = 0.7
        name.font = UI.Font.Summary.name
        stat.font = UI.Font.Summary.stat
        statUnit.font = UI.Font.Summary.statUnit
        statUnit.alpha = 0.7
        
        leading = leadingAnchors
        
        constraints(anchorTo: anchorView)
    }
        
    func calculateNameWidth() {
        // nuke all nimations
        self.subviews.forEach({$0.layer.removeAllAnimations()})
        self.layer.removeAllAnimations()
        //
        let secondsToPanFullContainer: CGFloat = 2.0
        let standardWidth = UI.Sizing.topLinePieceWidth-UI.Sizing.objectPadding
        let pixelsPerSecond = standardWidth/secondsToPanFullContainer
        let calcHeight = UI.Sizing.topLineHeight/3
        calcFontWidth = name.text!.width(withConstrainedHeight: calcHeight, font: name.font)
        let duration = Double(calcFontWidth/pixelsPerSecond)
        nameWidth.constant = calcFontWidth
        self.layoutIfNeeded()
        let newCenter = (leading == 1) ? -(standardWidth-calcFontWidth) : (standardWidth-calcFontWidth)
//        print(drinkName.text!, center, standardWidth, calcFontWidth!, standardWidth-calcFontWidth!)
        (standardWidth < calcFontWidth && labelAnimation == false) ? startAnimation(for: duration, toCenter: newCenter) : nil
    }

    func startAnimation(for duration: Double, toCenter center: CGFloat) {
        labelAnimation = true
        //Animating the label automatically change as per your requirement
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: duration, delay: 1, options: ([.curveEaseInOut, .repeat, .autoreverse])
                , animations: ({
                    self.name.transform = CGAffineTransform(translationX: center, y: 0.0)
                }), completion: { (completed) in
                    self.name.transform = .identity
                    self.labelAnimation = false
            })
        })
    }
    
    // MARK: - NSLayoutConstraints
    func constraints(anchorTo anchorView: UIView) {
        for obj in [self,category,name,stat,statUnit] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        if leading == 0 {
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: anchorView.leadingAnchor),
                category.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.Padding.summary),
                name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.Padding.summary),
                stat.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.Padding.summary),
                statUnit.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.Padding.summary),
            ])
        }
        else if leading == 1 {
            NSLayoutConstraint.activate([
                trailingAnchor.constraint(equalTo: anchorView.trailingAnchor),
                category.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.Padding.summary),
                name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.Padding.summary),
                stat.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.Padding.summary),
                statUnit.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.Padding.summary),
            ])
        }
        nameWidth = name.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.summaryCell)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.Width.summaryCell),
            heightAnchor.constraint(equalTo: anchorView.heightAnchor),
            topAnchor.constraint(equalTo: anchorView.topAnchor),
            category.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.summaryCell),
            category.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.summaryCategory),
            category.topAnchor.constraint(equalTo: topAnchor),
            nameWidth,
            name.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.summaryName),
            name.topAnchor.constraint(equalTo: category.bottomAnchor),
            stat.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.summaryCell),
            stat.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.summaryStat),
            stat.topAnchor.constraint(equalTo: name.bottomAnchor),
            statUnit.widthAnchor.constraint(equalToConstant: UI.Sizing.Width.summaryCell),
            statUnit.heightAnchor.constraint(equalToConstant: UI.Sizing.Height.summaryStatUnit),
            statUnit.topAnchor.constraint(equalTo: stat.bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
