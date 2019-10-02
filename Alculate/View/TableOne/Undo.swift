//
//  Undo.swift
//  Alculate
//
//  Created by Max Sergent on 10/2/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

class Undo: UIView {
         
    // Objects
    let confirm = UIButton()
    let close = UIButton()
    
    var undoBottom = NSLayoutConstraint()
    
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
        let buttons = [confirm,close]
        let buttonText = ["Undo delete?", "X"]
        for i in 0..<buttons.count {
            buttons[i].contentVerticalAlignment = .center
            buttons[i].translatesAutoresizingMaskIntoConstraints = false
            buttons[i].setTitle(buttonText[i], for: .normal)
            addSubview(buttons[i])
            buttons[i].tag = i
            buttons[i].backgroundColor = .clear
        }
        confirm.contentHorizontalAlignment = .center
        close.contentHorizontalAlignment = .right
        // MARK: - NSLayoutConstraints
        undoBottom = bottomAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: UI.Sizing.appNavigationHeight*(2/3))
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.appNavigationHeight*(2/3)),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            undoBottom,
            confirm.widthAnchor.constraint(equalToConstant: UI.Sizing.widthObjectPadding-UI.Sizing.appNavigationHeight*(4/3)*(2/3)),
            confirm.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirm.heightAnchor.constraint(equalToConstant: UI.Sizing.appNavigationHeight*(2/3)*(2/3)),
            confirm.topAnchor.constraint(equalTo: topAnchor),
            close.widthAnchor.constraint(equalToConstant: UI.Sizing.appNavigationHeight*(2/3)*(2/3)),
            close.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding),
            close.heightAnchor.constraint(equalToConstant: UI.Sizing.appNavigationHeight*(2/3)*(2/3)),
            close.topAnchor.constraint(equalTo: topAnchor)
        ])
        //
//        let gradientLayer1 = CAGradientLayer()
//        let gradientLayer2 = CAGradientLayer()
//        let gradientLayer3 = CAGradientLayer()
//        for (index, gl) in [gradientLayer1,gradientLayer2,gradientLayer3].enumerated() {
//            gl.frame = CGRect(origin: CGPoint(x: UI.Sizing.width/3*CGFloat(index),y: 0), size: CGSize(width: UI.Sizing.width/3, height: UI.Sizing.appNavigationHeight))
//            gl.colors = [UI.Color.alcoholTypes[index].withAlphaComponent(0.0).cgColor, UIColor.black.cgColor]
//            gl.locations = [0.0,0.55]//(UI.Sizing.appNavigationGradient as NSNumber?)!,1.0]
//            self.layer.insertSublayer(gl, at: 0)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
