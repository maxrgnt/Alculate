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
    let bestBeerName = UILabel()
    let bestLiquorName = UILabel()
    let bestWineName = UILabel()
    let bestBeerStat = UILabel()
    let bestLiquorStat = UILabel()
    let bestWineStat = UILabel()
    
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
        for label in [bestBeerName, bestLiquorName, bestWineName] {
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.font = UI.Font.cellHeaderFont
            label.textAlignment = .center
        }
        bestBeerName.backgroundColor = .lightGray
        bestBeerStat.backgroundColor = .lightGray
        bestWineName.backgroundColor = .darkGray
        bestWineStat.backgroundColor = .darkGray
        for label in [bestBeerStat, bestLiquorStat, bestWineStat] {
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.font = UI.Font.cellHeaderFont
            label.textAlignment = .center
        }
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.subLineHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            topAnchor.constraint(equalTo: ViewController.topAnchor, constant: UI.Sizing.subLineTop),
            bestBeerName.leadingAnchor.constraint(equalTo: leadingAnchor),
            bestLiquorName.centerXAnchor.constraint(equalTo: centerXAnchor),
            bestWineName.trailingAnchor.constraint(equalTo: trailingAnchor),
            bestBeerStat.leadingAnchor.constraint(equalTo: leadingAnchor),
            bestLiquorStat.centerXAnchor.constraint(equalTo: centerXAnchor),
            bestWineStat.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        for label in [bestBeerName, bestLiquorName, bestWineName] {
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
                label.heightAnchor.constraint(equalToConstant: UI.Sizing.subLineHeight/2),
                label.topAnchor.constraint(equalTo: topAnchor)
            ])
        }
        for label in [bestBeerStat, bestLiquorStat, bestWineStat] {
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
                label.heightAnchor.constraint(equalToConstant: UI.Sizing.subLineHeight/2),
                label.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
