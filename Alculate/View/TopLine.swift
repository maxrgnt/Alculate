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
    let bestPriceName = UILabel()
    let bestPriceStat = UILabel()
    let bestCountName = UILabel()
    let bestCountStat = UILabel()

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        backgroundColor = .clear
        clipsToBounds = true
        // Object settings
        for obj in [bestPriceName,bestCountName] {
            addSubview(obj)
            obj.textColor = .darkGray
            obj.font = UI.Font.headerFont
            obj.textAlignment = .center
        }
        for obj in [bestPriceStat,bestCountStat] {
            addSubview(obj)
            obj.textColor = .gray
            obj.font = UI.Font.headerFont
            obj.textAlignment = .center
        }
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        for obj in [bestPriceName, bestCountName, bestPriceStat, bestCountStat] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.topLineTop),
            bestPriceName.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/2),
            bestPriceName.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            bestPriceName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            bestPriceName.topAnchor.constraint(equalTo: topAnchor),
            bestPriceStat.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/2),
            bestPriceStat.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            bestPriceStat.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            bestPriceStat.bottomAnchor.constraint(equalTo: bottomAnchor),
            bestCountName.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/2),
            bestCountName.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            bestCountName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            bestCountName.topAnchor.constraint(equalTo: topAnchor),
            bestCountStat.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/2),
            bestCountStat.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            bestCountStat.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            bestCountStat.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
