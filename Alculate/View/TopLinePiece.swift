//
//  TopLinePiece.swift
//  Alculate
//
//  Created by Max Sergent on 10/9/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TopLinePiece: UIView {
    
    // Objects
    let category = UILabel()
    let drinkName = UILabel()
    let value = UILabel()
    let valueDescription = UILabel()
    let icon = UIImageView()

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build(iconName: String, alignText: NSTextAlignment, leadingAnchors: Int) {
        // MARK: - View/Object Settings
        // View settings
        backgroundColor = UI.Color.alculatePurpleDark
        clipsToBounds = true
        // Object settings
        for label in [category,drinkName,value,valueDescription] {
            addSubview(label)
            label.textColor = UI.Color.softWhite
            label.textAlignment = alignText
        }
        category.textAlignment = .center
        category.font = UI.Font.topLineCategory
        category.alpha = 0.7
        drinkName.font = UI.Font.topLinePrimary
        value.font = UI.Font.topLinePrimary
        valueDescription.font = UI.Font.topLineSecondary
        valueDescription.alpha = 0.7
        //
        addSubview(icon)
        icon.image = UIImage(named: iconName)
        icon.alpha = 0.7
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [category,drinkName,value,valueDescription,icon] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        let categoryHeight = UI.Sizing.topLineHeight/6
        let drinkNameHeight = UI.Sizing.topLineHeight/3
        let valueHeight = UI.Sizing.topLineHeight/3
        let valueDescriptionHeight = UI.Sizing.topLineHeight/6
        let topLineWidth = UI.Sizing.topLinePieceWidth-UI.Sizing.objectPadding
        let valuePiecesWidth = UI.Sizing.topLinePieceWidth-UI.Sizing.objectPadding-UI.Sizing.topLineHeight/3
        let iconDiameter = UI.Sizing.topLineHeight*(2/5)
        //
        if leadingAnchors == 0 {
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
                drinkName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
                value.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
                valueDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
                icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding/2)
            ])
        } else if leadingAnchors == 1 {
            NSLayoutConstraint.activate([
                trailingAnchor.constraint(equalTo: ViewController.trailingAnchor),
                drinkName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
                value.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
                valueDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
                icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding/2)
            ])
        }
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.topLinePieceWidth),
            heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight),
            topAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: UI.Sizing.topLineTop),
            category.widthAnchor.constraint(equalToConstant: topLineWidth),
            category.heightAnchor.constraint(equalToConstant: categoryHeight),
            category.centerXAnchor.constraint(equalTo: centerXAnchor),
            category.topAnchor.constraint(equalTo: topAnchor),
            drinkName.widthAnchor.constraint(equalToConstant: topLineWidth),
            drinkName.heightAnchor.constraint(equalToConstant: drinkNameHeight),
            drinkName.topAnchor.constraint(equalTo: category.bottomAnchor),
            value.widthAnchor.constraint(equalToConstant: valuePiecesWidth),
            value.heightAnchor.constraint(equalToConstant: valueHeight),
            value.topAnchor.constraint(equalTo: drinkName.bottomAnchor),
            valueDescription.widthAnchor.constraint(equalToConstant: valuePiecesWidth),
            valueDescription.heightAnchor.constraint(equalToConstant: valueDescriptionHeight),
            valueDescription.topAnchor.constraint(equalTo: value.bottomAnchor),
            icon.widthAnchor.constraint(equalToConstant: iconDiameter),
            icon.heightAnchor.constraint(equalToConstant: iconDiameter),
            icon.bottomAnchor.constraint(equalTo: valueDescription.bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
