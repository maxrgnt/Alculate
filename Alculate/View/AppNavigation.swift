//
//  AppNavigation.swift
//  Alculate
//
//  Created by Max Sergent on 9/25/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class AppNavigation: UIView {
         
    // Objects
    let left = UIButton()
    let middle = UIButton()
    let right = UIButton()
    let beer = UIButton()
    let liquor = UIButton()
    let wine = UIButton()
    //
    var selectingType = false
    
    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        clipsToBounds = true
        // Object settings
        left.contentHorizontalAlignment = .left
        middle.contentHorizontalAlignment = .center
        right.contentHorizontalAlignment = .right
        middle.addTarget(self, action: #selector(presentAlcoholTypes), for: .touchUpInside)
        let buttons = [left, middle, right]
        let buttonText = ["X", "+", "//"]
        for i in 0..<buttons.count {
            buttons[i].translatesAutoresizingMaskIntoConstraints = false
            buttons[i].setTitle(buttonText[i], for: .normal)
            addSubview(buttons[i])
            buttons[i].tag = i
            buttons[i].backgroundColor = .darkGray
        }
        let alcButtons = [beer, liquor, wine]
        let alcButtonText = ["B", "L", "W"]
        for i in 0..<alcButtons.count {
            alcButtons[i].isHidden = true
            alcButtons[i].contentHorizontalAlignment = .center
            alcButtons[i].contentVerticalAlignment = .center
            alcButtons[i].translatesAutoresizingMaskIntoConstraints = false
            alcButtons[i].setTitle(alcButtonText[i], for: .normal)
            addSubview(alcButtons[i])
            alcButtons[i].tag = 20+i
            alcButtons[i].backgroundColor = UI.Color.alcoholTypes[i]
        }
        // MARK: - NSLayoutConstraints
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight*2+UI.Sizing.objectPadding),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            bottomAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: -UI.Sizing.statusBar.height),
            left.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            middle.centerXAnchor.constraint(equalTo: centerXAnchor),
            right.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            liquor.centerXAnchor.constraint(equalTo: middle.centerXAnchor),
            beer.trailingAnchor.constraint(equalTo: liquor.leadingAnchor, constant: -UI.Sizing.objectPadding),
            wine.leadingAnchor.constraint(equalTo: liquor.trailingAnchor, constant: UI.Sizing.objectPadding)
            ])
        for i in 0..<buttons.count {
            NSLayoutConstraint.activate([
                buttons[i].widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding/3),
                buttons[i].heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
                buttons[i].bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        for i in 0..<alcButtons.count {
            NSLayoutConstraint.activate([
                alcButtons[i].widthAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
                alcButtons[i].heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
                alcButtons[i].bottomAnchor.constraint(equalTo: middle.topAnchor, constant: -UI.Sizing.objectPadding)
            ])
        }
    }
    
    @objc func presentAlcoholTypes() {
        for button in [beer,liquor,wine] {
            button.isHidden = true
        }
        middle.setTitle("+", for: .normal)
        if !selectingType {
            for button in [beer,liquor,wine] {
                button.isHidden = false
            }
            middle.setTitle("-", for: .normal)
        }
        selectingType = !selectingType
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
