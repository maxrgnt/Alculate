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
    var drinkNameWidth: NSLayoutConstraint!
    
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
        category.textAlignment = .center
        category.font = UI.Font.topLineCategory
        name.font = UI.Font.topLinePrimary
        stat.font = UI.Font.topLinePrimary
        statUnit.font = UI.Font.topLineSecondary
        leading = leadingAnchors
        
        constraints(anchorTo: anchorView)
    }
    
    // MARK: - NSLayoutConstraints
    func constraints(anchorTo anchorView: UIView) {
        for obj in [self,category,name,stat,statUnit] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        let categoryHeight = UI.Sizing.topLineHeight/6
        let drinkNameHeight = UI.Sizing.topLineHeight/3
        let valueHeight = UI.Sizing.topLineHeight/3
        let valueDescriptionHeight = UI.Sizing.topLineHeight/6
        let topLineWidth = UI.Sizing.topLinePieceWidth-(UI.Sizing.objectPadding)
        let valuePiecesWidth = UI.Sizing.topLinePieceWidth-UI.Sizing.objectPadding-UI.Sizing.topLineHeight/3

        if leading == 0 {
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: anchorView.leadingAnchor),
                name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
                stat.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
                statUnit.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            ])
        }
        else if leading == 1 {
            NSLayoutConstraint.activate([
                trailingAnchor.constraint(equalTo: anchorView.trailingAnchor),
                name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
                stat.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
                statUnit.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            ])
        }
        drinkNameWidth = name.widthAnchor.constraint(equalToConstant: topLineWidth)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.topLinePieceWidth-UI.Sizing.objectPadding/2),
            heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight),
            topAnchor.constraint(equalTo: anchorView.topAnchor),
            category.widthAnchor.constraint(equalToConstant: topLineWidth),
            category.heightAnchor.constraint(equalToConstant: categoryHeight),
            category.centerXAnchor.constraint(equalTo: centerXAnchor),
            category.topAnchor.constraint(equalTo: topAnchor),
            drinkNameWidth,
            name.heightAnchor.constraint(equalToConstant: drinkNameHeight),
            name.topAnchor.constraint(equalTo: category.bottomAnchor),
            stat.widthAnchor.constraint(equalToConstant: valuePiecesWidth),
            stat.heightAnchor.constraint(equalToConstant: valueHeight),
            stat.topAnchor.constraint(equalTo: name.bottomAnchor),
            statUnit.widthAnchor.constraint(equalToConstant: valuePiecesWidth),
            statUnit.heightAnchor.constraint(equalToConstant: valueDescriptionHeight),
            statUnit.topAnchor.constraint(equalTo: stat.bottomAnchor)
            ])
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
        drinkNameWidth.constant = calcFontWidth
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
