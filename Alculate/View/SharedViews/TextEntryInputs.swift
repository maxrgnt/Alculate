//
//  TextEntryInputs.swift
//  Alculate
//
//  Created by Max Sergent on 10/16/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TextEntryInputs: UIView {

    //MARK: Definitions
    // Objects
    let icon = UIImageView()
    let name = UIButton()
    let abv = UIButton()
    let size = UIButton()
    let oz = UIButton()
    let ml = UIButton()
    let price = UIButton()
    var fields: [UIButton] = []

    //MARK: Initialization
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setup() {
        clipsToBounds = true
        backgroundColor = .clear
        objectSettings()
        constraints()
    }
    
    //MARK: Object Settings
    func objectSettings() {
        addSubview(icon)
        let titles = ["begin typing a name","abv","size","oz","ml","price"]
        for (i,field) in [name,abv,size,oz,ml,price].enumerated() {
            field.tag = (i>4) ? i-2 : i
            field.alpha = 0.5
            field.isHidden = (i>2&&i<5) ? true : false
            (i<3||i>4) ? fields.append(field) : nil
            addSubview(field)
            field.setTitle(titles[i], for: .normal)
            field.backgroundColor = .clear
            field.titleLabel?.font = UI.Font.TextEntry.field
            field.contentHorizontalAlignment = (i<3||i>4) ? .left : .center
            field.setTitleColor(UI.Color.Font.standard, for: .normal)
        }
    }
    
    //MARK: Constraints
    func constraints() {
        nameConstraints()
        abvConstraints()
        sizeConstraints()
        ozConstraints()
        mlConstraints()
        priceConstraints()
        iconConstraints()
    }
    
}
