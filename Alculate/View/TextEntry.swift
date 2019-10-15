//
//  TextEntry.swift
//  Alculate
//
//  Created by Max Sergent on 10/14/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit

protocol TextEntryDelegate: AnyObject {
    func hideTextEntry()
}

class TextEntry: UIView, UITextFieldDelegate {
 
    // Delegate object for Protocol above
    var textEntryDelegate: TextEntryDelegate?

    // Constraints
    var top: NSLayoutConstraint!
    
    // Objects
    let field = UITextField()
    let navigator = TextNavigator()
    let icon = UIImageView()
    let name = UIButton()
    
    // Variables
    var entryLevel = 0

    init() {
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func build() {
        // MARK: - View/Object Settings
        // View settings
        clipsToBounds = true
        backgroundColor = .clear
        roundCorners(corners: [.topLeft,.topRight], radius: UI.Sizing.textEntryRadius)
        layer.borderWidth = UI.Sizing.containerBorder*2
        layer.borderColor = UI.Color.alculatePurpleLite.cgColor
        // Blur object settings
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurEffectView)
        // Vibrancy object settings
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.contentView.addSubview(vibrancyView)
        // Initialize pan gesture recognizer to dismiss view
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down]
        for direction in directions {
            let sudheer = UISwipeGestureRecognizer(target: self, action: #selector(reactToSwipe))
            sudheer.direction = direction
            addGestureRecognizer(sudheer)
        }
        //
        addSubview(field)
        field.delegate = self
        field.autocorrectionType = .no
        //
        vibrancyView.contentView.addSubview(navigator)
        navigator.build()
        for button in [navigator.exit,navigator.backward,navigator.forward] {
            button.addTarget(self, action: #selector(navigateEntryLevel), for: .touchUpInside)
        }
        //
        addSubview(icon)
        //
        let titles = ["Begin typing Name"]
        for (i,field) in [name].enumerated() {
            field.tag = i
            addSubview(field)
            field.setTitle(titles[i], for: .normal)
            field.contentHorizontalAlignment = .left
            field.setTitleColor(UI.Color.softWhite, for: .normal)
        }
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        for obj in [icon,name] {
            obj.translatesAutoresizingMaskIntoConstraints = false
        }
        top = topAnchor.constraint(equalTo: ViewController.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([
            // View constraints
            widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryHeight+UI.Sizing.textEntryBounceBuffer),
            leadingAnchor.constraint(equalTo: ViewController.leadingAnchor),
            top,
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -20),
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            vibrancyView.topAnchor.constraint(equalTo: blurEffectView.topAnchor),
            vibrancyView.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor),
            vibrancyView.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor),
            vibrancyView.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor),
            name.topAnchor.constraint(equalTo: topAnchor, constant: UI.Sizing.objectPadding),
            name.heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryFieldHeight),
            name.widthAnchor.constraint(equalToConstant: UI.Sizing.textEntryFieldWidth),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UI.Sizing.objectPadding),
            icon.bottomAnchor.constraint(equalTo: name.bottomAnchor),
            icon.heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryIconDiameter),
            icon.widthAnchor.constraint(equalToConstant: UI.Sizing.textEntryIconDiameter),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UI.Sizing.objectPadding)
            ])
    }

    @objc func navigateEntryLevel(sender: UIButton) {
        if sender.tag == 0 {
            self.textEntryDelegate?.hideTextEntry()
        }
        else {
            entryLevel += sender.tag
            entryLevel = (entryLevel < 0) ? 0 : entryLevel
            entryLevel = (entryLevel > 3) ? 3 : entryLevel
            animateTextEntry(toLevel: entryLevel)
        }
    }
    
    func animateTextEntry(toLevel level: Int) {
        let adj = (-CGFloat(level)*UI.Sizing.textEntryFieldHeight)+UI.Sizing.textEntryTop
        top.constant = adj
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3,
                       options: [.allowUserInteraction,.curveEaseOut], animations: {
                        self.superview!.layoutIfNeeded()
        })
    }
    
    @objc func reactToSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
//            animateTextEntry(toLevel: 3)
        } else if sender.direction == .down {
            navigateEntryLevel(sender: navigator.exit)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
