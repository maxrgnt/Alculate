//
//  ComparisonContainer.swift
//  Alculate
//
//  Created by Max Sergent on 10/10/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class ComparisonContainer: UIView {
    
    // Objects
    let drinkName = UILabel()
    let drinkInfo = UILabel()
    let value = UILabel()
    let valueDescription = UILabel()
    let effect = UILabel()
    let effectDescription = UILabel()
    let remove = UIButton()

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
        NSLayoutConstraint.activate([
            drinkName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: borderOffset),
            drinkName.widthAnchor.constraint(equalTo: widthAnchor, constant: -borderOffset),
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
