//
//  TopLine.swift
//  Alculate
//
//  Created by Max Sergent on 9/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class TopLine: UIView {
    
    // Objects
    let namePrice = UILabel()
    let statPrice = UILabel()
    
    let nameRatio = UILabel()
    let statRatio = UILabel()

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        backgroundColor = .gray
        clipsToBounds = true
        // Object settings
        for obj in [namePrice,nameRatio] {
            addSubview(obj)
            obj.textColor = .black
            obj.font = UI.Font.headerFont
            obj.textAlignment = .center
        }
        for obj in [statPrice,statRatio] {
            addSubview(obj)
            obj.textColor = .black
            obj.font = UI.Font.headerFont
            obj.textAlignment = .center
        }
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        namePrice.translatesAutoresizingMaskIntoConstraints = false
        nameRatio.translatesAutoresizingMaskIntoConstraints = false
        statPrice.translatesAutoresizingMaskIntoConstraints = false
        statRatio.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.topLineTop),
            namePrice.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/2),
            namePrice.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            namePrice.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            namePrice.topAnchor.constraint(equalTo: topAnchor),
            statPrice.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/2),
            statPrice.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            statPrice.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            statPrice.bottomAnchor.constraint(equalTo: bottomAnchor),
            nameRatio.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/2),
            nameRatio.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            nameRatio.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            nameRatio.topAnchor.constraint(equalTo: topAnchor),
            statRatio.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/2),
            statRatio.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            statRatio.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            statRatio.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
