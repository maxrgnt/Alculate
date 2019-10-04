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
    let name = UILabel()
    let stat = UILabel()
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
        clipsToBounds = true
        // Object settings
        addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .black
        name.font = UI.Font.headerFont
        name.textAlignment = .center
        //
        addSubview(stat)
        stat.translatesAutoresizingMaskIntoConstraints = false
        stat.textColor = .black
        stat.font = UI.Font.headerFont
        stat.textAlignment = .center
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.topLineTop),
            name.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
            name.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            name.topAnchor.constraint(equalTo: topAnchor),
            stat.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding),
            stat.heightAnchor.constraint(equalToConstant: UI.Sizing.topLineHeight/2),
            stat.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            stat.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
