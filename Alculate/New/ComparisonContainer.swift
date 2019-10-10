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
        backgroundColor = UI.Color.alculatePurpleLite
        layer.borderWidth = UI.Sizing.cellObjectBorder
        layer.borderColor = UI.Color.alculatePurpleDark.cgColor
        roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.comparisonContainerRadius)
        // Object settings
        for label in [drinkName,drinkInfo,value,valueDescription,effect,effectDescription] {
            addSubview(label)
            label.textColor = UI.Color.softWhite
            label.textAlignment = .left
        }
        effect.textAlignment = .center
        effectDescription.textAlignment = .center
        //
        drinkName.font = UI.Font.cellHeaderFont
        drinkInfo.font = UI.Font.cellHeaderFont
        value.font = UI.Font.cellHeaderFont
        valueDescription.font = UI.Font.cellHeaderFont
        effect.font = UI.Font.cellHeaderFont
        effectDescription.font = UI.Font.cellHeaderFont
        //
        drinkName.text = "Coors"
        drinkInfo.text = "4.1% | 12oz | $4.00"
        value.text = "$2.00"
        valueDescription.text = "per shot"
        effect.text = "2.1"
        effectDescription.text = "shots"
             
        // MARK: - NSLayoutConstraints
        for obj in [drinkName,drinkInfo,value,valueDescription,effect,effectDescription,remove] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        let drinkNameHeight: CGFloat = (1/3)
        let drinkInfoHeight: CGFloat = (1/6)
        // value and effect
        let categoryHeight: CGFloat = (1/3)
        // value and effect
        let descriptionHeight: CGFloat = (1/6)
        //
        let valueWidth: CGFloat = (2/3)
        let effectWidth: CGFloat = (1/3)
        //
        NSLayoutConstraint.activate([
            drinkName.leadingAnchor.constraint(equalTo: leadingAnchor),
            drinkName.widthAnchor.constraint(equalTo: widthAnchor),
            drinkName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: drinkNameHeight),
            drinkName.topAnchor.constraint(equalTo: topAnchor),
            drinkInfo.leadingAnchor.constraint(equalTo: leadingAnchor),
            drinkInfo.widthAnchor.constraint(equalTo: widthAnchor),
            drinkInfo.heightAnchor.constraint(equalTo: heightAnchor, multiplier: drinkInfoHeight),
            drinkInfo.topAnchor.constraint(equalTo: drinkName.bottomAnchor),
            value.leadingAnchor.constraint(equalTo: leadingAnchor),
            value.widthAnchor.constraint(equalTo: widthAnchor, multiplier: valueWidth),
            value.heightAnchor.constraint(equalTo: heightAnchor, multiplier: categoryHeight),
            value.topAnchor.constraint(equalTo: drinkInfo.bottomAnchor),
            valueDescription.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueDescription.widthAnchor.constraint(equalTo: value.widthAnchor),
            valueDescription.heightAnchor.constraint(equalTo: heightAnchor, multiplier: descriptionHeight),
            valueDescription.topAnchor.constraint(equalTo: value.bottomAnchor),
            effect.trailingAnchor.constraint(equalTo: trailingAnchor),
            effect.widthAnchor.constraint(equalTo: widthAnchor, multiplier: effectWidth),
            effect.heightAnchor.constraint(equalTo: heightAnchor, multiplier: categoryHeight),
            effect.topAnchor.constraint(equalTo: drinkInfo.bottomAnchor),
            effectDescription.trailingAnchor.constraint(equalTo: trailingAnchor),
            effectDescription.widthAnchor.constraint(equalTo: effect.widthAnchor),
            effectDescription.heightAnchor.constraint(equalTo: heightAnchor, multiplier: descriptionHeight),
            effectDescription.topAnchor.constraint(equalTo: effect.bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
