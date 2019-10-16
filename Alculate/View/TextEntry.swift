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
    let inputs = TextEntryInputs()
    
    // Variables
    var inputLevel = 0

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
        // Required for textView delegates to work
        addSubview(field)
        field.delegate = self
        field.autocorrectionType = .no
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
        vibrancyView.contentView.addSubview(navigator)
        navigator.build()
        navigator.backward.addTarget(self, action: #selector(navigateEntryLevel), for: .touchUpInside)
        navigator.forward.addTarget(self, action: #selector(navigateEntryLevel), for: .touchUpInside)
        addSubview(inputs)
        inputs.build()
        
        // MARK: - NSLayoutConstraints
        translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
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
            inputs.widthAnchor.constraint(equalToConstant: UI.Sizing.width),
            inputs.heightAnchor.constraint(equalToConstant: UI.Sizing.textEntryHeight+UI.Sizing.textEntryBounceBuffer),
            inputs.centerXAnchor.constraint(equalTo: centerXAnchor),
            inputs.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    @objc func navigateEntryLevel(sender: UIButton) {
        inputLevel += sender.tag
        inputLevel = (inputLevel < 0) ? 0 : inputLevel
        inputLevel = (inputLevel > 3) ? 3 : inputLevel
//            animateTextEntry(toLevel: entryLevel)
    }
    
    func animateTextEntry(toLevel level: Int) {
        top.constant = UI.Sizing.textEntryTopFull
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3,
                       options: [.allowUserInteraction,.curveEaseOut], animations: {
                        self.superview!.layoutIfNeeded()
        })
    }
    
    @objc func reactToSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
//            animateTextEntry(toLevel: 3)
        } else if sender.direction == .down {
            self.textEntryDelegate?.hideTextEntry()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
