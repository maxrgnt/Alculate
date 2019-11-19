//
//  Summary.swift
//  Alculate
//
//  Created by Max Sergent on 10/9/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Summary: UIView {
    
    // Constraints
    var top: NSLayoutConstraint!
    var drinkNameWidth: NSLayoutConstraint!
    
    // Objects
    let category = UILabel()
    let drinkName = UILabel()
    let value = UILabel()
    let valueDescription = UILabel()
    let icon = UIImageView()
    
    // Variables
    var calcFontWidth: CGFloat!
    var labelAnimation = false
    var leading: Int! = 0

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build(iconName: String, alignText: NSTextAlignment, leadingAnchors: Int) {
        // MARK: - View/Object Settings
        // View settings
        backgroundColor = UI.Color.bgDarkest
        clipsToBounds = true
        // Object settings
        for label in [category,drinkName,value,valueDescription] {
            addSubview(label)
            label.textColor = UI.Color.fontWhite
            label.textAlignment = alignText
            label.alpha = 0.0
        }
        category.textAlignment = .center
        category.font = UI.Font.topLineCategory
//        category.alpha = 0.7
        drinkName.font = UI.Font.topLinePrimary
        value.font = UI.Font.topLinePrimary
        valueDescription.font = UI.Font.topLineSecondary
//        valueDescription.alpha = 0.7
        leading = leadingAnchors
        //
//        addSubview(icon)
//        icon.image = UIImage(named: iconName)
//        icon.alpha = 0.7
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [category,drinkName,value,valueDescription/*,icon*/] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        let categoryHeight = UI.Sizing.topLineHeight/6
        let drinkNameHeight = UI.Sizing.topLineHeight/3
        let valueHeight = UI.Sizing.topLineHeight/3
        let valueDescriptionHeight = UI.Sizing.topLineHeight/6
        let topLineWidth = UI.Sizing.topLinePieceWidth-(UI.Sizing.objectPadding)
        let valuePiecesWidth = UI.Sizing.topLinePieceWidth-UI.Sizing.objectPadding-UI.Sizing.topLineHeight/3
//        let iconDiameter = UI.Sizing.topLineHeight*(2/5)
        //
        if leadingAnchors == 0 {
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
                drinkName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
                value.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
                valueDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
//                icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding/2)
            ])
        } else if leadingAnchors == 1 {
            NSLayoutConstraint.activate([
                trailingAnchor.constraint(equalTo: ViewController.trailingAnchor),
                drinkName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
                value.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
                valueDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
//                icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding/2)
            ])
        }
        top = topAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: -UI.Sizing.subMenuHeight) // UI.Sizing.topLineTop)
        drinkNameWidth = drinkName.widthAnchor.constraint(equalToConstant: topLineWidth)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.topLinePieceWidth-UI.Sizing.objectPadding/2),
            heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight),
            top,
            category.widthAnchor.constraint(equalToConstant: topLineWidth),
            category.heightAnchor.constraint(equalToConstant: categoryHeight),
            category.centerXAnchor.constraint(equalTo: centerXAnchor),
            category.topAnchor.constraint(equalTo: topAnchor),
            drinkNameWidth,
            drinkName.heightAnchor.constraint(equalToConstant: drinkNameHeight),
            drinkName.topAnchor.constraint(equalTo: category.bottomAnchor),
//            drinkName.centerXAnchor.constraint(equalTo: centerXAnchor),
            value.widthAnchor.constraint(equalToConstant: valuePiecesWidth),
            value.heightAnchor.constraint(equalToConstant: valueHeight),
            value.topAnchor.constraint(equalTo: drinkName.bottomAnchor),
            valueDescription.widthAnchor.constraint(equalToConstant: valuePiecesWidth),
            valueDescription.heightAnchor.constraint(equalToConstant: valueDescriptionHeight),
            valueDescription.topAnchor.constraint(equalTo: value.bottomAnchor),
//            icon.widthAnchor.constraint(equalToConstant: iconDiameter),
//            icon.heightAnchor.constraint(equalToConstant: iconDiameter),
//            icon.bottomAnchor.constraint(equalTo: valueDescription.bottomAnchor)
            ])
    }

    func moveTopAnchor(to newConstant: CGFloat) {
        if top != nil {
            let newAlpha = (newConstant == -UI.Sizing.subMenuHeight) ? 0.0 : 1.0
            let descriptionAlpha = (newConstant == -UI.Sizing.subMenuHeight) ? 0.0 : 0.7
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut
                , animations: ({
                    for label in [self.category,self.drinkName,self.value] {
                        label.alpha = CGFloat(newAlpha)
                    }
                    for label in [self.valueDescription] {
                        label.alpha = CGFloat(descriptionAlpha)
                    }
                    self.top.constant = newConstant
                    self.superview!.layoutIfNeeded()
                }), completion: { (completed) in
                    // pass
                }
            )
        }
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
        calcFontWidth = drinkName.text!.width(withConstrainedHeight: calcHeight, font: drinkName.font)
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
                    self.drinkName.transform = CGAffineTransform(translationX: center, y: 0.0)
                }), completion: { (completed) in
                    self.drinkName.transform = .identity
                    self.labelAnimation = false
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
