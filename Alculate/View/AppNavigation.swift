//
//  AppNavigation.swift
//  Alculate
//
//  Created by Max Sergent on 9/25/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class AppNavigation: UIView {
         
    var appNavBottom = NSLayoutConstraint()

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
        //

        // Object settings
        left.contentHorizontalAlignment = .center
        middle.contentHorizontalAlignment = .center
        right.contentHorizontalAlignment = .center
        middle.addTarget(self, action: #selector(presentAlcoholTypes), for: .touchUpInside)
        let buttons = [left, middle, right]
        let buttonText = ["X", "+", "//"]
        for i in 0..<buttons.count {
            buttons[i].translatesAutoresizingMaskIntoConstraints = false
            buttons[i].setTitle(buttonText[i], for: .normal)
            addSubview(buttons[i])
            buttons[i].tag = i
            buttons[i].backgroundColor = .clear
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
        appNavBottom = bottomAnchor.constraint(equalTo: ViewController.bottomAnchor)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.appNavigationHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            appNavBottom,
            left.leadingAnchor.constraint(equalTo: leadingAnchor),
            middle.centerXAnchor.constraint(equalTo: centerXAnchor),
            right.trailingAnchor.constraint(equalTo: trailingAnchor),
            liquor.centerXAnchor.constraint(equalTo: middle.centerXAnchor),
            beer.trailingAnchor.constraint(equalTo: liquor.leadingAnchor, constant: -UI.Sizing.objectPadding),
            wine.leadingAnchor.constraint(equalTo: liquor.trailingAnchor, constant: UI.Sizing.objectPadding)
            ])
        for i in 0..<buttons.count {
            NSLayoutConstraint.activate([
                buttons[i].widthAnchor.constraint(equalToConstant: UI.Sizing.width/3),
                buttons[i].heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
                buttons[i].bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UI.Sizing.statusBar.height)
            ])
        }
        for i in 0..<alcButtons.count {
            NSLayoutConstraint.activate([
                alcButtons[i].widthAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
                alcButtons[i].heightAnchor.constraint(equalToConstant: UI.Sizing.headerHeight),
                alcButtons[i].bottomAnchor.constraint(equalTo: middle.topAnchor, constant: -UI.Sizing.objectPadding)
            ])
        }
        //
        let gradientLayer1 = CAGradientLayer()
        let gradientLayer2 = CAGradientLayer()
        let gradientLayer3 = CAGradientLayer()
        for (index, gl) in [gradientLayer1,gradientLayer2,gradientLayer3].enumerated() {
            gl.frame = CGRect(origin: CGPoint(x: UI.Sizing.width/3*CGFloat(index),y: 0), size: CGSize(width: UI.Sizing.width/3, height: UI.Sizing.appNavigationHeight))
            gl.colors = [UI.Color.alcoholTypes[index].withAlphaComponent(0.0).cgColor, UIColor.black.cgColor]
            gl.locations = [0.0,0.55]//(UI.Sizing.appNavigationGradient as NSNumber?)!,1.0]
            self.layer.insertSublayer(gl, at: 0)
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
