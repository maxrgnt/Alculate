//
//  ComparisonContainer.swift
//  Alculate
//
//  Created by Max Sergent on 10/10/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class ComparisonContainer: UIView {
    
    // Constraints
    var drinkNameWidth: NSLayoutConstraint!

    // Objects
    let drinkName = UILabel()
    let drinkInfo = UILabel()
    let value = UILabel()
    let valueDescription = UILabel()
    let effect = UILabel()
    let effectDescription = UILabel()
    let remove = UIButton()
    
    // Variables
    var calcFontWidth: CGFloat!
    var originalCenter: (x: CGFloat
    , y: CGFloat)!
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        clipsToBounds = false
        backgroundColor = UI.Color.bgDark
        layer.borderWidth = UI.Sizing.containerBorder
        layer.borderColor = UI.Color.bgDarkest.cgColor
        roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.containerRadius)
        // Object settings
        for label in [drinkName,/*drinkInfo,*/value,valueDescription,effect,effectDescription] {
            addSubview(label)
            label.textColor = UI.Color.fontWhite
            label.textAlignment = .left
        }
        effect.textAlignment = .right
        effectDescription.textAlignment = .right
        //
        drinkName.font = UI.Font.cellStubFont
//        drinkInfo.font = UI.Font.cellStubFont2
        value.font = UI.Font.cellStubFont2
        value.alpha = 0.85
        valueDescription.font = UI.Font.cellStubFont3
        effect.font = UI.Font.cellStubFont2
        effect.alpha = 0.85
        effectDescription.font = UI.Font.cellStubFont3
        //
//        drinkInfo.alpha = 0.7
        valueDescription.text = "per shot"
        valueDescription.alpha = 0.7
        effectDescription.text = "shots"
        effectDescription.alpha = 0.7
             
        // MARK: - NSLayoutConstraints
        for obj in [drinkName,drinkInfo,value,valueDescription,effect,effectDescription,remove] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        let drinkNameHeight: CGFloat = 0.4166666667 // (1/3)+((1/3)-(1/4))
//        let drinkInfoHeight: CGFloat = (1/6)
        // value and effect
        let categoryHeight: CGFloat = (1/3)
        // value and effect
        let descriptionHeight: CGFloat = (1/4)
        //
        let valueWidth: CGFloat = (2/3)
        let effectWidth: CGFloat = (1/3)
        //
        let borderOffset = 2*UI.Sizing.containerBorder
        //
        drinkNameWidth = drinkName.widthAnchor.constraint(equalToConstant: UI.Sizing.containerDiameter-borderOffset)
        NSLayoutConstraint.activate([
            drinkName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: borderOffset),
            drinkNameWidth,
            drinkName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: drinkNameHeight),
            drinkName.topAnchor.constraint(equalTo: topAnchor),
//            drinkInfo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: borderOffset),
//            drinkInfo.widthAnchor.constraint(equalTo: widthAnchor, constant: -borderOffset),
//            drinkInfo.heightAnchor.constraint(equalTo: heightAnchor, multiplier: drinkInfoHeight),
//            drinkInfo.topAnchor.constraint(equalTo: drinkName.bottomAnchor),
            value.leadingAnchor.constraint(equalTo: leadingAnchor, constant: borderOffset),
            value.widthAnchor.constraint(equalTo: widthAnchor, multiplier: valueWidth, constant: -borderOffset),
            value.heightAnchor.constraint(equalTo: heightAnchor, multiplier: categoryHeight),
            value.topAnchor.constraint(equalTo: drinkName.bottomAnchor),
            valueDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: borderOffset),
            valueDescription.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -borderOffset),
            valueDescription.heightAnchor.constraint(equalTo: heightAnchor, multiplier: descriptionHeight),
            valueDescription.topAnchor.constraint(equalTo: value.bottomAnchor, constant: -borderOffset),
            effect.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -borderOffset),
            effect.widthAnchor.constraint(equalTo: widthAnchor, multiplier: effectWidth, constant: -borderOffset),
            effect.heightAnchor.constraint(equalTo: heightAnchor, multiplier: categoryHeight),
            effect.topAnchor.constraint(equalTo: drinkName.bottomAnchor),
            effectDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -borderOffset),
            effectDescription.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -borderOffset),
            effectDescription.heightAnchor.constraint(equalTo: heightAnchor, multiplier: descriptionHeight),
            effectDescription.topAnchor.constraint(equalTo: effect.bottomAnchor, constant: -borderOffset)
            ])
        originalCenter = (x: drinkName.center.x, y: drinkName.center.y)
    }
    
    func calculateNameWidth() {
        let secondsToPanFullContainer: CGFloat = 5.0
        let standardWidth = (UI.Sizing.containerDiameter-2*UI.Sizing.containerBorder)
        let pixelsPerSecond = standardWidth/secondsToPanFullContainer
        let calcHeight = 0.4166666667 * UI.Sizing.containerHeight
        calcFontWidth = drinkName.text!.width(withConstrainedHeight: calcHeight, font: drinkName.font)
        let duration = Double(calcFontWidth/pixelsPerSecond)
        drinkNameWidth.constant = calcFontWidth
//        print("\(drinkName.text!): \(drinkNameWidth!)")
        standardWidth < calcFontWidth ? startAnimation(for: duration) : nil
    }

    func startAnimation(for duration: Double) {
        // nuke all nimations
        self.subviews.forEach({$0.layer.removeAllAnimations()})
        self.layer.removeAllAnimations()
        self.layoutIfNeeded()
        originalCenter = (originalCenter == (x: 0.0, y: 0.0)) ? (x: drinkName.center.x, y: drinkName.center.y) : originalCenter
        //Animating the label automatically change as per your requirement
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: duration, delay: 1, options: ([/*.beginFromCurrentState,*/ .curveLinear, .repeat])
                , animations: ({
                    self.drinkName.center = CGPoint(x: 0 - self.drinkNameWidth.constant / 2, y: self.drinkName.center.y)
                    print("\(self.drinkName.text!): \(self.drinkName.center) | \(self.originalCenter!)")
                }), completion: { (completed) in
//                    self.drinkName.center = CGPoint(x: 0 - self.originalCenter.x, y: self.originalCenter.y)
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
