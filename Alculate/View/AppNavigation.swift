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
    var middleWidth = NSLayoutConstraint()
    var middleHeight = NSLayoutConstraint()
    
    var beerTrailing = NSLayoutConstraint()
    var wineLeading = NSLayoutConstraint()
    var beerTop = NSLayoutConstraint()
    var liquorTop = NSLayoutConstraint()
    var wineTop = NSLayoutConstraint()

    // Objects
    let left = UIButton()
    let middle = UIButton()
    let right = UIButton()
    let beer = UIButton()
    let liquor = UIButton()
    let wine = UIButton()
    //
    var selectingType = false
    var alculateType = "price"
    
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
        left.contentHorizontalAlignment = .center
        middle.contentHorizontalAlignment = .center
        right.contentHorizontalAlignment = .center
        middle.addTarget(self, action: #selector(presentAlcoholTypes), for: .touchUpInside)
        let buttons = [left, middle, right]
        let buttonText = ["$/%", "+", "//"]
        for i in 0..<buttons.count {
            buttons[i].translatesAutoresizingMaskIntoConstraints = false
            buttons[i].setTitle(buttonText[i], for: .normal)
            buttons[i].setTitleColor(.black, for: .normal)
            addSubview(buttons[i])
            buttons[i].tag = i
            buttons[i].backgroundColor = UI.Color.softWhite
        }
        left.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.width/12)
        middle.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.width/8)
        right.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.width/12)
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
            alcButtons[i].setTitleColor(.black, for: .normal)
            alcButtons[i].backgroundColor = UI.Color.softWhite //UI.Color.alcoholTypes[i]
            alcButtons[i].roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: UI.Sizing.width/12)
        }
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        appNavBottom = bottomAnchor.constraint(equalTo: ViewController.bottomAnchor)
        middleWidth = middle.widthAnchor.constraint(equalToConstant: UI.Sizing.width/4)
        middleHeight = middle.heightAnchor.constraint(equalToConstant: UI.Sizing.width/4)
        beerTrailing = beer.trailingAnchor.constraint(equalTo: liquor.leadingAnchor)
        wineLeading = wine.leadingAnchor.constraint(equalTo: liquor.trailingAnchor)
        beerTop = beer.topAnchor.constraint(equalTo: middle.topAnchor)
        liquorTop = liquor.topAnchor.constraint(equalTo: middle.topAnchor)
        wineTop = wine.topAnchor.constraint(equalTo: middle.topAnchor)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.appNavigationHeight),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            appNavBottom,
            left.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            middle.centerXAnchor.constraint(equalTo: centerXAnchor),
            right.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            liquor.centerXAnchor.constraint(equalTo: middle.centerXAnchor),
            beerTrailing,
            wineLeading,
            beerTop,
            liquorTop,
            wineTop,
            left.widthAnchor.constraint(equalToConstant: UI.Sizing.width/6),
            left.heightAnchor.constraint(equalToConstant: UI.Sizing.width/6),
            left.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UI.Sizing.statusBar.height),
            middleWidth,
            middleHeight,
            middle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UI.Sizing.statusBar.height),
            right.widthAnchor.constraint(equalToConstant: UI.Sizing.width/6),
            right.heightAnchor.constraint(equalToConstant: UI.Sizing.width/6),
            right.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UI.Sizing.statusBar.height)
        ])
        for i in 0..<alcButtons.count {
            NSLayoutConstraint.activate([
                alcButtons[i].widthAnchor.constraint(equalToConstant: UI.Sizing.width/6),
                alcButtons[i].heightAnchor.constraint(equalToConstant: UI.Sizing.width/6),
            ])
        }
        //
        let gradientLayer1 = CAGradientLayer()
        let gradientLayer2 = CAGradientLayer()
        let gradientLayer3 = CAGradientLayer()
        for (index, gl) in [gradientLayer1,gradientLayer2,gradientLayer3].enumerated() {
            gl.frame = CGRect(origin: CGPoint(x: UI.Sizing.width/3*CGFloat(index),y: 0), size: CGSize(width: UI.Sizing.width/3, height: UI.Sizing.appNavigationHeight))
            gl.colors = [UI.Color.alculatePurpleLite.withAlphaComponent(0.0).cgColor, UI.Color.alculatePurpleDark.cgColor]
            gl.locations = [0.0,0.55]//(UI.Sizing.appNavigationGradient as NSNumber?)!,1.0]
            self.layer.insertSublayer(gl, at: 0)
        }
    }
    
    @objc func presentAlcoholTypes() {
        var tempRadius = UI.Sizing.width/8
        if !selectingType {
            tempRadius = UI.Sizing.width/12
            showAlcoholTypes(true)
        }
        else {
            showAlcoholTypes(false)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.middle.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: tempRadius)
            self.layoutIfNeeded()
        })
        selectingType = !selectingType
    }
    
    func showAlcoholTypes(_ shouldShow:Bool) {
        if shouldShow {
            for button in [beer,liquor,wine] {
                button.isHidden = false
            }
            middle.setTitle("-", for: .normal)
            middleWidth.constant = UI.Sizing.width/6
            middleHeight.constant = UI.Sizing.width/6
            beerTop.constant = -UI.Sizing.width/6-UI.Sizing.objectPadding
            liquorTop.constant = -UI.Sizing.width/6-UI.Sizing.objectPadding
            wineTop.constant = -UI.Sizing.width/6-UI.Sizing.objectPadding
            beerTrailing.constant = -UI.Sizing.objectPadding
            wineLeading.constant = UI.Sizing.objectPadding
        }
        else {
            for button in [beer,liquor,wine] {
                button.isHidden = true
            }
            middle.setTitle("+", for: .normal)
            middleWidth.constant = UI.Sizing.width/4
            middleHeight.constant = UI.Sizing.width/4
            beerTop.constant = 0
            liquorTop.constant = 0
            wineTop.constant = 0
            beerTrailing.constant = 0
            wineLeading.constant = 0
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
