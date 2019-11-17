//
//  TextEntryInputs.swift
//  Alculate
//
//  Created by Max Sergent on 10/16/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TextEntryInputs: UIView {

    // Objects
    let icon = UIImageView()
    let name = UIButton()
    let abv = UIButton()
    let size = UIButton()
    let oz = UIButton()
    let ml = UIButton()
    let price = UIButton()
    
    var fields: [UIButton] = []

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        clipsToBounds = true
        backgroundColor = .clear
        //
        addSubview(icon)
        let titles = ["begin typing a name","abv","size","oz","ml","price"]
        for (i,field) in [name,abv,size,oz,ml,price].enumerated() {
            field.tag = (i>4) ? i-2 : i
            (i<3||i>4) ? fields.append(field) : nil
            addSubview(field)
            field.alpha = 0.5
            field.setTitle(titles[i], for: .normal)
            field.backgroundColor = .clear
            field.titleLabel?.font = UI.Font.cellHeaderFont
            field.contentHorizontalAlignment = (i<3||i>4) ? .left : .center
            field.setTitleColor(UI.Color.fontWhite, for: .normal)
        }
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [icon,name,abv,size,oz,ml,price] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: topAnchor, constant: UI.Sizing.objectPadding),
            abv.topAnchor.constraint(equalTo: name.bottomAnchor),
            size.topAnchor.constraint(equalTo: abv.bottomAnchor),
            oz.topAnchor.constraint(equalTo: size.topAnchor),
            ml.topAnchor.constraint(equalTo: size.topAnchor),
            price.topAnchor.constraint(equalTo: size.bottomAnchor),
            icon.bottomAnchor.constraint(equalTo: name.bottomAnchor),
            icon.heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryIconDiameter),
            icon.widthAnchor.constraint(equalToConstant: UI.Sizing.textEntryIconDiameter),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding)
            ])
        for (i,obj) in [name,abv,size,price].enumerated() {
            let widthConstant = (i==2) ? UI.Sizing.textEntryFieldWidthForSize : UI.Sizing.textEntryFieldWidth
            NSLayoutConstraint.activate([
                obj.heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryFieldHeight),
                obj.widthAnchor.constraint(equalToConstant: widthConstant),
                obj.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding)
            ])
        }
        for (i,obj) in [oz,ml].enumerated() {
            let leadingConstant = (i==0) ? 0 : UI.Sizing.textEntryIconDiameter
            NSLayoutConstraint.activate([
                obj.heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryFieldHeight),
                obj.widthAnchor.constraint(equalToConstant: UI.Sizing.textEntryIconDiameter),
                obj.leadingAnchor.constraint(equalTo: size.trailingAnchor, constant: leadingConstant)
            ])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
