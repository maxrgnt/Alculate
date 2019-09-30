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
    let bestAlcohol = UILabel()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .darkGray
        clipsToBounds = true
        // Object settings
        addSubview(bestAlcohol)
        bestAlcohol.translatesAutoresizingMaskIntoConstraints = false
        bestAlcohol.textColor = .black
        bestAlcohol.font = UI.Font.headerFont
        bestAlcohol.textAlignment = .center
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.statusBar.height+UI.Sizing.headerHeight),
            bestAlcohol.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
            bestAlcohol.heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
            bestAlcohol.centerXAnchor.constraint(equalTo: centerXAnchor),
            bestAlcohol.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
