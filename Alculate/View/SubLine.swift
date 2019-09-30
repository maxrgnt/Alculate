//
//  SubLine.swift
//  Alculate
//
//  Created by Max Sergent on 9/30/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class SubLine: UIView {
         
    // Objects
    let bestBeer = UILabel()
    let bestLiquor = UILabel()
    let bestWine = UILabel()
    
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
        for label in [bestBeer, bestLiquor, bestWine] {
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.font = UI.Font.cellFont
            label.textAlignment = .center
        }
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.subLineHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.subLineTop),
            bestBeer.leadingAnchor.constraint(equalTo: leadingAnchor),
            bestLiquor.centerXAnchor.constraint(equalTo: centerXAnchor),
            bestWine.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        for label in [bestBeer, bestLiquor, bestWine] {
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
                label.heightAnchor.constraint(equalToConstant: UI.Sizing.subLineHeight),
                label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
